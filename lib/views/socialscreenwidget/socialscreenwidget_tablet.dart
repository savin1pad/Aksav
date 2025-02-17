part of socialscreenwidget_view;

class _SocialscreenwidgetTablet extends StatelessWidget {
  const _SocialscreenwidgetTablet();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Social Screen'),
        backgroundColor: Colors.indigo,
      ),
      body: const Center(
        child: Text('SocialscreenwidgetTablet'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.indigo,
        child: const Icon(Icons.add),
      ),
    );
  }
}