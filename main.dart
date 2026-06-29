import 'package:flutter/material.dart';
import 'dart:math'; // ২ নম্বর লাইনের ভুলটি এখানে ফিক্স করা হয়েছে

void main() {
  runApp(const MiltonCloneApp());
}

class MiltonCloneApp extends StatelessWidget {
  const MiltonCloneApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Milton Type App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WalletService _walletService = WalletService();
  final VoiceRoomService _voiceRoomService = VoiceRoomService();

  // ডেমো স্টেট ডেটা
  int userCoins = 1000000; // ১ মিলিয়ন কয়েন
  double earnings = 1.0;   // ১ ডলার
  String userRole = "ব্যবহারকারী"; 

  // স্লট গেমের জন্য ভেরিয়েবল
  List<int> slotResults = [7, 7, 7];
  bool isSpinning = false;

  void _showSnackBar(String message, Color bgColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)), 
        backgroundColor: bgColor,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // স্লট গেম খেলার মেইন লজিক ফাংশন
  void _playSlotGame() {
    if (userCoins < 10000) {
      _showSnackBar("দুঃখিত! গেম খেলতে কমপক্ষে ১০,০০০ কয়েন লাগবে।", Colors.red.shade700);
      return;
    }

    setState(() {
      isSpinning = true;
      userCoins -= 10000; // প্রতি স্পিনে ১০,০০০ কয়েন ফি
    });

    // একটু সময় নিয়ে চাকা ঘোরার ফিল দেওয়া (Fake Delay)
    Future.delayed(const Duration(milliseconds: 600), () {
      final random = Random();
      int s1 = random.nextInt(9) + 1; // ১ থেকে ৯ পর্যন্ত সংখ্যা
      int s2 = random.nextInt(9) + 1;
      int s3 = random.nextInt(9) + 1;

      setState(() {
        slotResults = [s1, s2, s3];
        isSpinning = false;

        // ৩টি সংখ্যা মিললে জ্যাকপট
        if (s1 == s2 && s2 == s3) {
          userCoins += 100000; // ১ লাখ কয়েন পুরস্কার
          _showSnackBar("🎉🎉 বাম্পার জ্যাকপট! আপনি ১,০০,০০০ কয়েন জিতেছেন!!", Colors.green.shade700);
        } 
        // ২টি সংখ্যা মিললে ছোট পুরস্কার
        else if (s1 == s2 || s2 == s3 || s1 == s3) {
          userCoins += 20000; // ২০ হাজার কয়েন পুরস্কার
          _showSnackBar("💰 দারুণ! ২টা মিলেছে, আপনি ২০,০০০ কয়েন জিতেছেন!", Colors.blue.shade700);
        } 
        // না মিললে লস
        else {
          _showSnackBar("😢 ভাগ্য সহায় হয়নি! আবার চেষ্টা করুন।", Colors.orange.shade800);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Milton - party ও আর্নিং', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => _showSnackBar("কোন নতুন নোটিফিকেশন নেই", Colors.purple),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // প্রোফাইল ও ব্যালেন্সカード
              Card(
                color: Colors.purple.shade900,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          const CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.white,
                            child: Icon(Icons.person, size: 40, color: Colors.purple),
                          ),
                          const SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('আমার প্রোফাইল', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                              Text('পদবী: $userRole', style: const TextStyle(color: Colors.amber)),
                            ],
                          ),
                        ],
                      ),
                      const Divider(color: Colors.white24, height: 25),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              const Text('মোট কয়েন', style: TextStyle(color: Colors.white70)),
                              Text('$userCoins', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.amber)),
                            ],
                          ),
                          Column(
                            children: [
                              const Text('আয় (USD)', style: TextStyle(color: Colors.white70)),
                              Text('\$${earnings.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // 🎰 স্লট গেম সেকশন 🎰
              Card(
                color: const Color(0xFF1F1A24),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15), side: const BorderSide(color: Colors.amber, width: 1.5)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.casino, color: Colors.amber, size: 24),
                          SizedBox(width: 8),
                          Text('লাকি স্লট গেম (১০,০০০ কয়েন ফি)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.amber)),
                        ],
                      ),
                      const SizedBox(height: 15),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: slotResults.map((val) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.purple, width: 2),
                            ),
                            child: Text(
                              isSpinning ? '?' : '$val',
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: isSpinning ? null : _playSlotGame,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber.shade700,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          icon: const Icon(Icons.refresh),
                          label: Text(isSpinning ? 'চাকা ঘুরছে...' : 'স্পিন করুন', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // রোল সিলেকশন
              const Text('আপনার রোল সিলেক্ট করুন (পরীক্ষামূলক)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: userRole,
                isExpanded: true,
                items: <String>['ব্যবহারকারী', 'সুপার এডমিন', 'এডমিন', 'বিডি (BD)', 'কয়েন সেলার', 'এজেন্সি'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    userRole = newValue!;
                  });
                },
              ),
              const SizedBox(height: 20),

              // মূল মেনু অপশনসমূহ
              const Text('মেনু ও ফিচার', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildMenuCard(Icons.mic, 'ভয়েস পার্টি রুম', Colors.blue, () {
                    var room = _voiceRoomService.createPartyRoom(roomName: "মিল্টন রকস্টার আড্ডা", hostName: "মিল্টন", roomType: "আড্ডা");
                    _showSnackBar(room['message'], Colors.blue.shade700);
                  }),
                  _buildMenuCard(Icons.account_balance_wallet, 'প্রতিদিনের উইথড্র', Colors.green, () {
                    var res = _walletService.requestWithdraw(coinsToWithdraw: 1000000, paymentMethod: "বিকাশ", phoneNumber: "017XXXXXXXX");
                    _showSnackBar(res['message'], Colors.green.shade700);
                  }),
                  _buildMenuCard(Icons.monetization_on, 'কয়েন ট্রান্সফার টেস্ট', Colors.orange, () {
                    var res = _walletService.transferCoins(senderRole: userRole, receiverRole: "এজেন্সি", amount: 200000, senderBalance: userCoins);
                    if(res['success']) {
                      setState(() { userCoins = res['newBalance']; });
                      _showSnackBar(res['message'], Colors.green.shade700);
                    } else {
                      _showSnackBar(res['message'], Colors.red.shade700);
                    }
                  }),
                  _buildMenuCard(Icons.card_giftcard, 'গিফট পাঠান (টেস্ট)', Colors.pink, () {
                    var res = _voiceRoomService.sendGift(senderId: "user1", receiverId: "host1", giftValueInCoins: 100000, senderCurrentCoins: userCoins);
                    if(res['success']) {
                      setState(() {
                        userCoins = res['senderNewBalance'];
                        earnings += res['hostEarningsInDollar'];
                      });
                      _showSnackBar(res['message'], Colors.pink.shade700);
                    } else {
                      _showSnackBar(res['message'], Colors.red.shade700);
                    }
                  }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuCard(IconData icon, String title, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Card(
        color: const Color(0xFF1E1E1E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: color),
              const SizedBox(height: 10),
              Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Wallet Service ---
class WalletService {
  final int coinsPerDollar = 1000000;
  double convertCoinsToDollar(int coins) => coins / coinsPerDollar;

  Map<String, dynamic> transferCoins({required String senderRole, required String receiverRole, required int amount, required int senderBalance}) {
    if (senderBalance < amount) return {"success": false, "message": "আপনার অ্যাকাউন্টে পর্যাপ্ত কয়েন নেই!"};
    if (senderRole == "ব্যবহারকারী") return {"success": false, "message": "সাধারণ ব্যবহারকারী সরাসরি কয়েন ট্রান্সফার করতে পারবেন না।"};
    return {"success": true, "message": "$amount কয়েন সফলভাবে ট্রান্সফার হয়েছে।", "newBalance": senderBalance - amount};
  }

  Map<String, dynamic> requestWithdraw({required int coinsToWithdraw, required String paymentMethod, required String phoneNumber}) {
    if (coinsToWithdraw < coinsPerDollar) return {"success": false, "message": "সর্বনিম্ন ১ মিলিয়ন (১০,০০,০০০) কয়েন না হলে উইথড্র করা যাবে না।"};
    return {"success": true, "message": "আপনার ${convertCoinsToDollar(coinsToWithdraw)} ডলার উইথড্র রিকোয়েস্ট সফল হয়েছে। $paymentMethod ($phoneNumber) নাম্বারে টাকা পৌঁছে যাবে।"};
  }
}

// --- Voice Room Service ---
class VoiceRoomService {
  Map<String, dynamic> createPartyRoom({required String roomName, required String hostName, required String roomType}) {
    return {"message": "$roomName রুমটি সফলভাবে তৈরি হয়েছে।"};
  }
  Map<String, dynamic> sendGift({required String senderId, required String receiverId, required int giftValueInCoins, required int senderCurrentCoins}) {
    if (senderCurrentCoins < giftValueInCoins) return {"success": false, "message": "দুঃখিত! গিফট পাঠানোর জন্য পর্যাপ্ত কয়েন নেই।"};
    return {"success": true, "message": "গিফট সফলভাবে পাঠানো হয়েছে!", "senderNewBalance": senderCurrentCoins - giftValueInCoins, "hostEarningsInDollar": giftValueInCoins / 1000000};
  }
}
