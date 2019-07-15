part of 'ExamPage.dart';

class _ExamHistoryPage extends StatefulWidget {
	@override State createState() => _ExamHistoryPageState();
}

class _ExamHistoryPageState extends State<_ExamHistoryPage> {
	ScrollController _scroll_controller;
	PagingController<Exam> _paging_controller;
	@override
	Widget build(BuildContext context) => new Scaffold(
		body: new NestedScrollView(
			controller: _scroll_controller,
			headerSliverBuilder: (_, __) => <Widget>[
				new SliverAppBar(
					title: new Text(
						S.of(context).history,
					),
				),
			],
			body: new ListPaging<Exam>(
				controller: _paging_controller,
				outer_scroll_controller: _scroll_controller,
				itemBuilder: ( _, item, index ) => new InkWell(
					child: new Card(
						elevation: CARD_ELEVATION,
						child: new Padding(
							padding: const EdgeInsets.all(20.0),
							child: new Column(
								children: <Widget>[
									new Text(
										new DateFormat("'Tanggal' dd MMMM yyyy 'pukul' hh:mm:ss", "id").format( item.date.toLocal() ),
										style: Theme.of(context).primaryTextTheme.title.copyWith( color: Theme.of(context).textTheme.body1.color ),
									),
									new Divider(
										height: 10.0,
									),
									new Text(
										"Skor ${ item.skor }",
										style: Theme.of(context).primaryTextTheme.title.copyWith( color: Theme.of(context).textTheme.body1.color ),
									),
								],
							)
						),
					),
					onTap: () => Navigator.of(context).push(
						new MaterialPageRoute(
							builder: ( _ ) => new ExamResultPage(
								result: item,
							),
						),
					),
				),
				onError: ( error, st ) {
					if ( error is MissingRequiredKeysException ) {
						print(error.missingKeys);
					}
					print(error);
					print(st);
					FlushbarHelper.createError(message: S.of(context).error_occurred).show(context);
				},
			),
		),
	);
	
	@override
	void initState() {
		_scroll_controller = new ScrollController();
		_paging_controller = new GraphQLPagingController(
			context: context,
			items_per_page: 25,
			transformer: ( final data ) => Exams.fromJson(data["loadExams"]),
			query_options: new QueryOptions(
				document: QUERY_LOAD_EXAMS,
				fetchPolicy: FetchPolicy.cacheAndNetwork,
			),
		);
		super.initState();
	}
	
}