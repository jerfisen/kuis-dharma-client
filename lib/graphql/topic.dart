const QUERY_TOPICS = r'''
query topics( $per_page: Int, $page: Int ) {
  topics( per_page: $per_page, page: $page ) {
    list {
      id
      name
    }
    page_info {
      total_pages
      total_result
      page
      per_page
    }
  }
}
''';