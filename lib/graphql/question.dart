const MUTATION_CREATE_QUESTIONS = r'''
mutation createQuestion(
  $text_content: String!,
  $media_content: [String!],
  $topics: [ID!]!,
  $answers: [ArgCreateAnswer!]!,
  $correct_answer: ID!
) {
  createQuestion(
    text_content: $text_content,
    media_content: $media_content,
    topics: $topics,
    correct_answer: $correct_answer,
  ) {
    id
    text_content
    media_content
    answers {
      id
      text_content
      media_content
    }
  }
}
''';

const QUERY_DO_EXAMS = r'''
query doExam( $length: Int!, $topic: ID! ) {
  doExam( length: $length, topic: $topic ) {
    id
    text_content
    media_content
    answers {
      id
      text_content
      media_content
    }
    topics {
      id
      name
    }
  }
}
''';