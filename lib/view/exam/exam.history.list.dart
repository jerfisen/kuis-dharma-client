part of 'ExamPage.dart';

class _ExamHistoryList extends StatefulWidget {
	@override _ExamHistoryListState createState() => _ExamHistoryListState();
}

class _ExamHistoryListState extends State<_ExamHistoryList> with Paging<_ExamHistoryList, Exam> {
	@override
	Widget getChild(BuildContext context, List<Exam> list) => new EasyRefresh(
		onRefresh: onRefresh,
		onLoad: onLoad,
		firstRefresh: true,
		child: new ListView.builder(
			itemCount: list.length,
			itemBuilder: ( _, final int index ) => new InkWell(
				child: new Card(
					elevation: CARD_ELEVATION,
					child: new Padding(
						padding: const EdgeInsets.all(20.0),
						child: new Column(
							children: <Widget>[
								new Text(
									new DateFormat("'Tanggal' dd MMMM yyyy 'pukul' hh:mm:ss", "id").format( list[index].date.toLocal() ),
									style: Theme.of(context).primaryTextTheme.title.copyWith( color: Theme.of(context).textTheme.body1.color ),
								),
								new Divider(
									height: 10.0,
								),
								new Text(
									"Skor ${ list[index].skor }",
									style: Theme.of(context).primaryTextTheme.title.copyWith( color: Theme.of(context).textTheme.body1.color ),
								),
							],
						)
					),
				),
				onTap: () => Navigator.of(context).push(
					new MaterialPageRoute(
						builder: ( _ ) => new ExamResultPage(
							result: list[index],
						),
					),
				),
			),
		),
	);
	
	@override
	PagingController<Exam> getPagingController() => new GraphQLPagingController(
		context: context,
		items_per_page: 25,
		transformer: ( final data ) => Exams.fromJson(data["loadExams"]),
		query_options: new QueryOptions(
			document: QUERY_LOAD_EXAMS,
			fetchPolicy: FetchPolicy.cacheAndNetwork,
		),
	);
	
	@override
	void onError(error, StackTrace st) {
		FlushbarHelper.createError(message: S.of(context).error_occurred).show(context);
	}
}