// ignore_for_file: unused_field, unused_local_variable, unused_element

part of log_view;

class _LogMobile extends StatefulWidget {
  final String goalId;
  const _LogMobile({Key? key, required this.goalId}) : super(key: key);

  @override
  State<_LogMobile> createState() => _LogMobileState();
}

class _LogMobileState extends State<_LogMobile> {
  final TextEditingController _messageController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;

  Future<void> _getImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = File(image.path);
      });
    }
  }

  _sendMessage() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          StreamBuilder(
            stream: _sendMessage(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Text('Error loading messages');
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // final messages = snapshot.data!;
              return ListView.builder(
                reverse: true,
                // itemCount: messages.length,
                itemBuilder: (context, index) {
                  // final messageData = messages[index].data();
                  // final message = messageData['message'];
                  // final imageUrl = messageData['imageUrl'];
                  return;
                  // return ListTile(
                  //   title: Column(
                  //     crossAxisAlignment: CrossAxisAlignment.start,
                  //     children: [
                  //       if (message != null) Text(message),
                  //       if (imageUrl != null)
                  //         Image.network(imageUrl, height: 200),
                  //     ],
                  //   ),
                  // );
                },
              );
            },
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.5,
              left: 10,
              right: 10,
            ),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your message...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: () {
                      final message = _messageController.text.trim();
                      if (message.isNotEmpty) {
                        // context.read<ChatBloc>().add(
                        //       SendMessageEvent(
                        //         goalId: widget.goalId,
                        //         message: message,
                        //         emailOrPhone: user.email!,
                        //         senderId: user.userId!,
                        //         messageId: DateTime.now()
                        //             .millisecondsSinceEpoch
                        //             .toString(),
                        //       ),
                        //     );
                        _messageController.clear();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
