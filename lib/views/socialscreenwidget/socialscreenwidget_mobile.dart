part of socialscreenwidget_view;

class _SocialscreenwidgetMobile extends StatefulWidget {
  const _SocialscreenwidgetMobile();

  @override
  State<_SocialscreenwidgetMobile> createState() => _SocialscreenwidgetMobileState();
}

class _SocialscreenwidgetMobileState extends State<_SocialscreenwidgetMobile> {
  final _repository = app<ZettelRepository>();
  List<ZettelNote> _zettels = [];

  Future<void> _loadZettels() async {
    final zettels = await _repository.getUserZettels(RepositoryProvider.of<UserModel>(context).userId!);
    setState(() {
      _zettels = zettels;
    });
  }

  @override
  void initState() {
    _loadZettels();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return GraphViewComplete(zettelNote: _zettels); 
  }
}