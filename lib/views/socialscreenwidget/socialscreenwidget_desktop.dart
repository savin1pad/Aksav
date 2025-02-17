part of socialscreenwidget_view;

class _SocialscreenwidgetDesktop extends StatelessWidget {
  const _SocialscreenwidgetDesktop();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Screen'),
        backgroundColor: Colors.amber,
      ),
      body: const Center(
        child: Text('SocialscreenwidgetDesktop'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.amber,
        child: const Icon(Icons.add),
      ),
    );
  }
}