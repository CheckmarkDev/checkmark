import linkifyStr from 'linkifyjs/string'

export default function linkify (content: string): string {
  return linkifyStr(content, {
    defaultProtocol: 'https',
    attributes: {
      rel: 'noopener nofollow'
    },
    className: 'text-blue-500 underline',
    target: {
      url: '_blank'
    }
  })
}
