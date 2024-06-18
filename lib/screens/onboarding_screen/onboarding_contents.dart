class OnboardingContents {
  final String title;
  final String image;
  final String desc;

  OnboardingContents({
    required this.title,
    required this.image,
    required this.desc,
  });
}

List<OnboardingContents> contents = [
  OnboardingContents(
    title: "Find best babysitter for your kid",
    image: "assets/images/onboarding/image1.png",
    desc: "Login to app and choose the best nanny for your children",
  ),
  OnboardingContents(
    title: "Schedule and relax",
    image: "assets/images/onboarding/image2.png",
    desc: "Concentrate on your activities, Nanny will take care of babies",
  ),
  OnboardingContents(
    title: "Your child's best care begins here",
    image: "assets/images/onboarding/image3.png",
    desc:
        "Start the app now",
  ),
];
