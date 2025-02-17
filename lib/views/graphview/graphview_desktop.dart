
part of graphview_view;

class _GraphViewDesktop extends StatelessWidget {
  const _GraphViewDesktop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Graph'),
      ),
      body: const Center(
        child: Text('GraphViewDesktop'),
      ),
    );
  }
}