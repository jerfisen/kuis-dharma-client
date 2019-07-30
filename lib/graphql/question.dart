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

const QUERY_DO_COUNT_QUESTIONS = r'''
query countQuestions( $topic: ID! ) {
  countQuestions( id: $topic )
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

const QUERY_DO_EXAMS_WITH_SEED = r'''
query doExam( $length: Int!, $topic: ID!, $seed: Int ) {
  doExam( length: $length, topic: $topic, seed: $seed ) {
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