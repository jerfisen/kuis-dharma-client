part of 'ExamPage.dart';

class _ExamHistoryPage extends StatelessWidget {
	@override Widget build(BuildContext context) => new Scaffold(
		body: new NestedScrollView(
			headerSliverBuilder: (_, __) => <Widget>[
				new SliverAppBar(
					title: new Text(
						S.of(context).history,
					),
				),
			],
			body: new _ExamHistoryList(),
		),
	);
}
