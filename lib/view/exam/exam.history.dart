part of 'ExamPage.dart';

class _ExamHistoryPage extends StatefulWidget {
	@override State createState() => _ExamHistoryPageState();
}

class _ExamHistoryPageState extends State<_ExamHistoryPage> {
	@override
	Widget build(BuildContext context) => new Scaffold(
		body: new NestedScrollView(
			headerSliverBuilder: (_, __) => <Widget>[
				new SliverAppBar(
					title: new Text(
						S.of(context).history,
					),
				),
			],
			body: new ListView(
				padding: const EdgeInsets.all(10.0),
				children: <Widget>[
					new Card(
						elevation: CARD_ELEVATION,
						child: new Padding(
							padding: const EdgeInsets.all(20.0),
							child: new Column(
								children: <Widget>[
									new Text(
										new DateFormat("'Tanggal' dd MMMM yyyy 'pukul' hh:mm:ss", "id").format( new DateTime.now() ),
										style: Theme.of(context).primaryTextTheme.title.copyWith( color: Theme.of(context).textTheme.body1.color ),
									),
									new Divider(
										height: 10.0,
									),
									new Text(
										"Slor 76.50",
										style: Theme.of(context).primaryTextTheme.title.copyWith( color: Theme.of(context).textTheme.body1.color ),
									),
								],
							)
						),
					),
					new Card(
						elevation: CARD_ELEVATION,
						child: new Padding(
							padding: const EdgeInsets.all(20.0),
							child: new Column(
								children: <Widget>[
									new Text(
										new DateFormat("'Tanggal' dd MMMM yyyy 'pukul' hh:mm:ss", "id").format( new DateTime.now().add(const Duration( days: -1 ) ) ),
										style: Theme.of(context).primaryTextTheme.title.copyWith( color: Theme.of(context).textTheme.body1.color ),
									),
									new Divider(
										height: 10.0,
									),
									new Text(
										"Slor 56.34",
										style: Theme.of(context).primaryTextTheme.title.copyWith( color: Theme.of(context).textTheme.body1.color ),
									),
								],
							)
						),
					),
					new Card(
						elevation: CARD_ELEVATION,
						child: new Padding(
							padding: const EdgeInsets.all(20.0),
							child: new Column(
								children: <Widget>[
									new Text(
										new DateFormat("'Tanggal' dd MMMM yyyy 'pukul' hh:mm:ss", "id").format( new DateTime.now().add(const Duration( days: -2 ) ) ),
										style: Theme.of(context).primaryTextTheme.title.copyWith( color: Theme.of(context).textTheme.body1.color ),
									),
									new Divider(
										height: 10.0,
									),
									new Text(
										"Slor 100.00",
										style: Theme.of(context).primaryTextTheme.title.copyWith( color: Theme.of(context).textTheme.body1.color ),
									),
								],
							)
						),
					),
				],
			),
		),
	);
}