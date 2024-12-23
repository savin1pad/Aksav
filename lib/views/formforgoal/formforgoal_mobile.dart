// ignore_for_file: unused_field, unused_local_variable

part of formforgoal_view;

class _FormforgoalMobile extends StatefulWidget {
  const _FormforgoalMobile();

  @override
  State<_FormforgoalMobile> createState() => _FormforgoalMobileState();
}

class _FormforgoalMobileState extends State<_FormforgoalMobile>
    with TickerProviderStateMixin, LogMixin {
  late AnimationController _waveAnimationController;
  late AnimationController _text1AnimationController;
  late AnimationController _text2AnimationController;
  late Animation<Offset> _text1SlideAnimation;
  late Animation<double> _text1FadeAnimation;
  late Animation<Offset> _text2SlideAnimation;
  late Animation<double> _text2FadeAnimation;
  final _backgroundColor = ConstantVars.maintheme;
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  File? _imageFile;

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // Function to handle form submission
  void _submitForm() {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      // Process form data and image
      String title = _titleController.text;
      String description = _descriptionController.text;
      // ... Your logic to upload image and data to server ...

      // Show success message or navigate to another screen
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Goal submitted successfully!')),
      );
    } else {
      // Show error message if form is invalid or image is not selected
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please fill all fields and upload an image.')),
      );
    }
  }

  final _colors = [
    ConstantVars.maintheme,
    ConstantVars.cardColorTheme,
  ];

  final _durations = [
    5000,
    4000,
  ];

  final _heightPercentages = [
    0.65,
    0.66,
  ];

  @override
  void initState() {
    super.initState();

    // Wave animation
    _waveAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    );
    _waveAnimationController.forward();

    // Text 1 animation
    _text1AnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..forward();
    _text1SlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _text1AnimationController,
      curve: Curves.decelerate,
    ));
    _text1FadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _text1AnimationController,
      curve: Curves.decelerate,
    ));

    // Text 2 animation (delayed)
    _text2AnimationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    _text2SlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _text2AnimationController,
      curve: Curves.decelerate,
    ));
    _text2FadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(_text2AnimationController)
      ..addListener(() {
        setState(() {
          // When text 2 fades in, text 1 fades out
          _text1FadeAnimation = Tween<double>(
            begin: 1.0,
            end: 0.0,
          ).animate(_text2AnimationController);
        });
      });
    // Delay the second text animation and navigate after it's done
    Future.delayed(const Duration(seconds: 3), () {
      _text2AnimationController.forward().then((_) {
        Future.delayed(const Duration(seconds: 2), () {
          // Replace this with your actual home screen navigation
        });
      });
    });
  }

  @override
  void dispose() {
    _waveAnimationController.dispose();
    _text1AnimationController.dispose();
    _text2AnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: WaveWidget(
              config: CustomConfig(
                colors: _colors,
                durations: _durations,
                heightPercentages: _heightPercentages,
              ),
              backgroundColor: _backgroundColor,
              size: const Size(double.infinity, double.infinity),
              waveAmplitude: 0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                // Wrap the Column with SingleChildScrollView
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Goal Title',
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a goal title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Goal Description',
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a goal description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    Center(
                      child: _imageFile == null
                          ? ElevatedButton(
                              onPressed: _pickImage,
                              child: const Text('Upload Image'),
                            )
                          : Image.file(
                              _imageFile!,
                              height: 200.0,
                              width: 200.0,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(height: 32.0),
                    if (_imageFile !=
                        null) // Show submit button only if image is uploaded
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: const Text('Submit Goal'),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
