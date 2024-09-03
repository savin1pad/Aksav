// ignore_for_file: public_member_api_docs, sort_constructors_first, curly_braces_in_flow_control_structures
// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

part of onboarding_view;

class _OnboardingMobile extends StatefulWidget {
  final String userId;
  final String email;
  final String documentId;
  _OnboardingMobile({
    Key? key,
    required this.userId,
    required this.email,
    required this.documentId,
  }) : super(key: key);

  @override
  State<_OnboardingMobile> createState() => _OnboardingMobileState();
}

class _OnboardingMobileState extends State<_OnboardingMobile>
    with TickerProviderStateMixin, LogMixin {
  XFile? _file;
  final TextEditingController _usernameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey();
  final GlobalKey<ScaffoldState> _dupliScaffoldKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  void initState() {
    context.read<AuthBloc>().add(
          FetchUserDetailsFromServer(userId: widget.userId),
        );
    super.initState();
  }

  ListTile _tile(String title, IconData icon) => ListTile(
        title: AnimatedTextKit(
          animatedTexts: [
            TypewriterAnimatedText(
              title,
              speed: Duration(milliseconds: 150),
            ),
          ],
        ),
        leading: Icon(
          icon,
          color: Colors.blue[500],
        ),
      );
  // ignore: unused_element
  _showImageDialog(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        title: const Center(
          child: Text(
            'Pick Image from?',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        contentPadding: const EdgeInsets.only(top: 20),
        content: SizedBox(
          height: 230,
          child: Column(
            children: [
              SimpleDialogOption(
                onPressed: () async {
                  final XFile? cameraImage =
                      await app<StorageRepository>().handlecameraOpening();
                  setState(() {
                    _file = cameraImage;
                  });
                  warningLog('$cameraImage $_file');

                  app<NavigatorService>().pop();
                },
                child: _tile('Camera', Icons.camera),
              ),
              SimpleDialogOption(
                onPressed: () async {
                  final XFile? galleryImage =
                      await app<StorageRepository>().handleGallerOpening();
                  setState(() {
                    _file = galleryImage;
                  });
                  warningLog('$galleryImage $_file');
                  app<NavigatorService>().pop();
                },
                child: _tile('Gallery', Icons.photo_album),
              ),
              SimpleDialogOption(
                child: _tile('Cancel', Icons.cancel),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        warningLog('$state');
        // if (state is DataLoadingAuth) {
        //   Future.delayed(Duration(seconds: 10), () {
        //     app<NavigatorService>().buildAndPush(
        //       LoginView(),
        //     );
        //   });
        // }

        if (state is AuthSuccess) {
          if (state.onBoardingCompleted == true) {
            app<NavigatorService>().buildAndPush(HomeView());
          }
        }
        if (state is ErrorFetchingUserData) {
          app<NavigatorService>().buildAndPush(
            LoginView(),
          );
        }
      },
      builder: (context, state) {
        if (state is DataLoadingAuth) {
          return Scaffold(
            key: _dupliScaffoldKey,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  Text('Setting up your account.....')
                ],
              ),
            ),
          );
        }
        return Scaffold(
          key: _scaffoldKey,
          body: Container(
            height: MediaQuery.of(context).size.height * 0.7,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.alphaBlend(Color(0xffD99EC9), Colors.orange),
                  Color.alphaBlend(Colors.pink, Colors.orange),
                ],
              ),
            ),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppBar(
                      automaticallyImplyLeading: false,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      actions: [
                        IconButton(
                          onPressed: () {},
                          icon: Text(
                            'Skip',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Center(
                      child: GestureDetector(
                        onTap: () => _showImageDialog(context),
                        child: Container(
                          height: 200,
                          width: 250,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(35),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  offset: Offset(0, 1),
                                  spreadRadius: 1,
                                  blurRadius: 3,
                                )
                              ]),
                          child: _file != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(35),
                                  child: Image.file(
                                    File(_file!.path),
                                    fit: BoxFit.fill,
                                  ),
                                )
                              : Column(
                                  children: [
                                    SizedBox(
                                      height: 30,
                                    ),
                                    Icon(
                                      Icons.person,
                                      size: 105,
                                    ),
                                    Text(
                                      'Upload Picture',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 30),
                                    )
                                  ],
                                ),
                        ),
                      ),
                    ),
                    SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 70),
                      child: TextFormField(
                        controller: _usernameController,
                        validator: (value) {
                          if (value == null) {
                            return 'Please enter a username';
                          } else if (value.length < 3) {
                            return 'Please enter a valid username';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          label: customText('Username'),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          focusColor: Colors.white,
                          hoverColor: Colors.white,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor:
                              WidgetStateProperty.all(Colors.orange),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                        ),
                        onPressed: () {
                          warningLog(_usernameController.text);
                          final formState = _formKey.currentState;
                          if (formState == null || !formState.validate())
                            return;
                          formState.save();
                          context.read<AuthBloc>().add(
                                UploadPictureAndUpdateUserData(
                                  file: _file,
                                  username: _usernameController.text.trim(),
                                  userId: widget.userId,
                                  email: widget.email,
                                  documentId: widget.documentId,
                                ),
                              );
                        },
                        // () => context.read<DataBloc>().add(
                        //   UpdateUserProfileDetails(xfile: xfile, username: username, userID: userID),),
                        child: Text('Submit'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
