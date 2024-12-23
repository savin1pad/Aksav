part of survey_2_view;

class _Survey2Mobile extends StatefulWidget {
  const _Survey2Mobile();

  @override
  State<_Survey2Mobile> createState() => _Survey2MobileState();
}

class _Survey2MobileState extends State<_Survey2Mobile> {
  final TextEditingController howController = TextEditingController();
  @override
  void initState() {
    super.initState();
    howController.text =
        RepositoryProvider.of<UserModel>(context).howMuchDoYouWant ?? '';
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
                'Question 2 of 3',
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
                      'Target amount to achieve this goal',
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
                controller: howController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
                ],
                style: const TextStyle(
                  fontFamily: 'UnileverShilling',
                  fontSize: 13,
                ),
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      //duration?.title = value;
                      user.whatDoYouWant = value;
                      goal.targetAmount = double.tryParse(value) ?? 0.0;
                    });
                  }
                },
                decoration: InputDecoration(
                  // labelText: 'Ethnicity',
                  // labelStyle: const TextStyle(
                  //   color: Color.fromARGB(255, 9, 93, 162),
                  // ),
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
