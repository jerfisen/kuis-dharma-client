const MUTATION_SAVE_EXAMS = r'''
mutation saveExam(
  $works: [ArgsWork!]!
) {
  saveExam(
    works: $works,
  ) {
    id
    date
    skor
    works {
      question {
        id
        text_content
        media_content
      }
      correct_answer {
        id
        text_content
        media_content
      }
      selected_answer {
        id
        text_content
        media_content
      }
      is_correct
    }
  }
}
''';

const QUERY_LOAD_EXAMS = r'''
query loadExams( $per_page: Int, $page: Int ) {
  loadExams( per_page: $per_page, page: $page ) {
    meta {
      total_pages
      total_result
      page
      per_page
    }
    list {
      id
      date
      user {
        uid
        email
        is_email_verified
        phone_number
        display_name
        photo_url
        disabled
      }
      skor
      works {
        question {
          id
          text_content
          media_content
        }
        correct_answer {
          id
          text_content
          media_content
        }
        selected_answer {
          id
          text_content
          media_content
        }
        is_correct
      }
    }
  }
}
''';