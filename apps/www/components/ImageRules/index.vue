<template>
  <div>
    <h3
      v-text="$trans('settings.titles.profile_rules')"
      class="text-base font-medium mb-2"
    />
    <p
      v-text="$trans('settings.paragraphs.profile_rules')"
      class="text-base mb-1"
    />
    <ul class="text-base list-disc pl-4 mb-8">
      <li
        v-text="$trans('settings.paragraphs.profile_rules.racism')"
      />
      <li
        v-text="$trans('settings.paragraphs.profile_rules.nsfw')"
      />
    </ul>
  </div>
</template>
