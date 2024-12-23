part of survey_4_view;

class _Survey4Mobile extends StatefulWidget {
  const _Survey4Mobile();

  @override
  State<_Survey4Mobile> createState() => _Survey4MobileState();
}

class _Survey4MobileState extends State<_Survey4Mobile> {
  final TextEditingController targetAmountController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final goal = RepositoryProvider.of<GoalModel>(context);
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/target.json',
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              'How much do you need to achieve this goal?',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: targetAmountController,
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              onChanged: (value) {
                if (value.isNotEmpty) {
                  goal.targetAmount = double.parse(value);
                }
              },
              decoration: InputDecoration(
                labelText: 'TARGET AMOUNT',
                prefixText: '\$',
                labelStyle: const TextStyle(color: Colors.white70),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white70),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
