export type PaginateResponseMeta = {
  current_page: number,
  total_pages: number,
  count: number
}

export type PaginateResponse<T> = {
  data: Array<T>,
  meta: PaginateResponseMeta
}
