# frozen_string_literal: true

module Webhooks
  class ProjectsController < ApplicationController
    before_action :set_project
    before_action :verify_signature

    api :POST, '/projects/:name/github'
    def github
      # Use the first user available for this project.
      # This should be changed when a project will have multiple users.
      user = @project.user

      # Handle releases
      task = nil
      if params[:action].present? && params[:release].present?
        task = Task.new(
          content: "Release : \"#{params[:release][:name]}\" (#{params[:release][:tag_name]}) \##{@project.slug}",
          state: Task.states[:done],
          source: Task.sources[:github],
          user: user
        )
      end

      # When a commit is pushed
      if params[:ref].present? && params[:commits].present?
        content = params[:commits]
          .map { |commit| "Commit : #{commit[:message]} par #{commit[:author][:name]} (#{params[:ref]})" }
          .join("\n")

        task = Task.new(
          content: "#{content}\n\##{@project.slug}",
          state: Task.states[:done],
          source: Task.sources[:github],
          user: user
        )
      end

      # When a pull request is created
      if params[:action].present? && params[:action] == 'opened' && params[:pull_request].present?
        task = Task.new(
          content: "Pull-request : #{params[:pull_request][:title]} ##{@project.slug}",
          state: Task.states[:done],
          source: Task.sources[:github],
          user: user
        )
      end

      if task.present?
        return render json: {}, status: :ok if task.save!

        return render json: { error: task.errors }, status: :unprocessable_entity
      end

      render json: {}, status: :ok
    end

    private

    def verify_signature
      secret = request.env['HTTP_X_HUB_SIGNATURE_256']

      begin
        raise StandardError, 'Secret is missing' if secret.nil?

        # See how it's done by Github (https://docs.github.com/en/developers/webhooks-and-events/webhooks/securing-your-webhooks)
        # rubocop:disable Style/StringConcatenation
        signature = 'sha256=' + OpenSSL::HMAC.hexdigest(OpenSSL::Digest.new('sha256'), @project.github_secret,
                                                        request.body.read)
        # rubocop:enable Style/StringConcatenation

        raise StandardError, 'Secret do not match Github signature' unless Rack::Utils.secure_compare(signature, secret)
      rescue StandardError => e
        render json: { errors: e.message }, status: :unauthorized
      end
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_project
      @project = Project.find_by!(slug: params[:id])
    end
  end
end
