import 'package:flutter/material.dart';
import 'package:final_project_flutter/components/appBar.dart';
import 'package:final_project_flutter/components/drawer.dart';
import 'package:final_project_flutter/components/bottomNav.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _animation1;
  late Animation<Color?> _animation2;

  @override
  void initState() {
    super.initState();

    // Animated gradient setup
    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 6))
          ..repeat(reverse: true);

    _animation1 = ColorTween(
      begin: Colors.blueAccent,
      end: Colors.purpleAccent,
    ).animate(_controller);

    _animation2 = ColorTween(
      begin: Colors.orangeAccent,
      end: Colors.pinkAccent,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  //call and email options
  void _showContactOptions() {
    showModalBottomSheet(
      context: context,
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ListTile(
            leading: const Icon(Icons.phone),
            title: const Text('Call: +65 88454281'),
            onTap: () async {
              final Uri phoneUri = Uri(scheme: 'tel', path: '+65 88454281');
              if (await canLaunchUrl(phoneUri)) {
                await launchUrl(phoneUri);
              }
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.email),
            title: const Text('Email: tanjosef03@gmail.com'),
            onTap: () async {
              final Uri emailUri = Uri(
                scheme: 'mailto',
                path: 'tanjosef03@gmail.com',
                query: 'subject=Contact from Train App&body=Hello,',
              );
              if (await canLaunchUrl(emailUri)) {
                await launchUrl(emailUri);
              }
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  //feedback dailouge box
  void _showFeedbackDialog() {
    final TextEditingController feedbackController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Send Feedback',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: feedbackController,
                maxLines: 5,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Type your feedback here...',
                ),
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () async {
                  final String feedback = feedbackController.text.trim();
                  if (feedback.isNotEmpty) {
                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'tanjosef33@gmail.com',
                      query:
                          'subject=Feedback from Train App&body=$feedback',
                    );
                    if (await canLaunchUrl(emailUri)) {
                      await launchUrl(emailUri);
                    }
                    Navigator.pop(context);
                  }
                },
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Scaffold(
          appBar: const AppAppBar(),
          drawer: const DrawerNav(),
          bottomNavigationBar: const AppBottomNav(),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [_animation1.value!, _animation2.value!],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Hero Image with Fade-in animation
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(seconds: 2),
                  builder: (context, double opacity, child) {
                    return Opacity(
                      opacity: opacity,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: const DecorationImage(
                            image: AssetImage('assets/group_pic.jpg'),
                            fit: BoxFit.cover,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                TweenAnimationBuilder(
                  tween: Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, Offset offset, child) {
                    return Transform.translate(
                      offset: offset * 100,
                      child: Card(
                        color: Colors.white.withOpacity(0.85),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: const Text(
                            'About Us',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),

                TweenAnimationBuilder(
                  tween: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero),
                  duration: const Duration(milliseconds: 1000),
                  builder: (context, Offset offset, child) {
                    return Transform.translate(
                      offset: offset * 100,
                      child: Card(
                        color: Colors.white.withOpacity(0.9),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: const Text(
                            'Welcome to the Train App! We are dedicated to providing you with the best experience for all your train travel needs. '
                            'Our app offers a range of features including ticket booking, real-time train schedules, and travel updates to ensure a smooth journey.',
                            style: TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _showContactOptions,
                      icon: const Icon(Icons.phone),
                      label: const Text('Contact Us'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _showFeedbackDialog,
                      icon: const Icon(Icons.feedback),
                      label: const Text('Feedback'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}