part of survey_1_view;

class _Survey1Mobile extends StatefulWidget {
  const _Survey1Mobile();

  @override
  State<_Survey1Mobile> createState() => _Survey1MobileState();
}

class _Survey1MobileState extends State<_Survey1Mobile> {
  final TextEditingController whatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    whatController.text =
        RepositoryProvider.of<UserModel>(context).whatIsYourName ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final user = RepositoryProvider.of<UserModel>(context);
    final goal = RepositoryProvider.of<GoalModel>(context);
    return Center(
      child: Container(
        height: 350,
        width: 350,
        decoration: const BoxDecoration(
          color: Color(0xffF3F4FE),
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                'Question 1 of 3',
                style: TextStyle(
                    color: Color(0xffA7A0A0),
                    fontSize: 13,
                    fontFamily: 'UnileverShilling',
                    fontWeight: FontWeight.w400),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12.0, top: 20.0),
              child: Row(
                children: [
                  Lottie.asset(
                    'assets/achieve.json',
                    height: 50,
                    width: 50,
                  ),
                  const Expanded(
                    child: Text(
                      'Define your goal?',
                      style: TextStyle(
                        fontFamily: 'UnileverShilling',
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: whatController,
                keyboardType: TextInputType.name,
                style: const TextStyle(
                  fontFamily: 'UnileverShilling',
                  fontSize: 13,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      // duration?.title = value;
                      user.whatIsYourName = value;
                      goal.goal = value;
                    });
                  }
                },
                decoration: InputDecoration(
                  labelText: 'GOAL',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 9, 93, 162),
                  ),
                  contentPadding: const EdgeInsets.all(10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 17, 103, 173),
                    ),
                  ),
                  fillColor: const Color.fromARGB(255, 255, 255, 255),
                  filled: true,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
