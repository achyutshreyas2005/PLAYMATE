import 'package:flutter/material.dart';
import 'package:swipe_cards/swipe_cards.dart';
import '../widgets/player_card.dart';
import '../services/user_service.dart';
import '../services/swipe_service.dart';
import '../models/user.dart';

class HomeSwipeScreen extends StatefulWidget {
  const HomeSwipeScreen({Key? key}) : super(key: key);

  @override
  _HomeSwipeScreenState createState() => _HomeSwipeScreenState();
}

class _HomeSwipeScreenState extends State<HomeSwipeScreen> {
  final List<SwipeItem> _swipeItems = <SwipeItem>[];
  MatchEngine? _matchEngine;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final UserService _userService = UserService();
  final SwipeService _swipeService = SwipeService();
  
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNearbyUsers();
  }

  Future<void> _loadNearbyUsers() async {
    setState(() {
      _isLoading = true;
    });
    
    List<User> users = await _userService.getNearbyUsers();
    
    _swipeItems.clear();
    for (User user in users) {
      _swipeItems.add(SwipeItem(
        content: user,
        likeAction: () async {
          bool isMatch = await _swipeService.swipeUser(user.id, "right");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(isMatch ? "It's a Match with ${user.name}!" : "Liked ${user.name}"),
              duration: const Duration(milliseconds: 1500),
              backgroundColor: isMatch ? Colors.pink : Colors.green,
            ));
          }
        },
        nopeAction: () async {
          await _swipeService.swipeUser(user.id, "left");
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Passed ${user.name}"),
              duration: const Duration(milliseconds: 500),
            ));
          }
        },
      ));
    }

    if (mounted) {
      setState(() {
        _matchEngine = MatchEngine(swipeItems: _swipeItems);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'DISCOVER',
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _loadNearbyUsers();
            },
          )
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Expanded(
                child: _isLoading 
                  ? const Center(child: CircularProgressIndicator())
                  : _swipeItems.isEmpty
                    ? const Center(child: Text("No more players nearby!"))
                    : SwipeCards(
                        matchEngine: _matchEngine!,
                        itemBuilder: (BuildContext context, int index) {
                          final User user = _swipeItems[index].content;
                          return PlayerCard(
                            name: user.name,
                            sport: user.sportsInterests.isNotEmpty ? user.sportsInterests.first : 'Any',
                            skillLevel: user.skillLevel,
                            distance: "Nearby", // Can be dynamic if distance is calculated
                            bio: user.bio ?? "Let's play!",
                            imageUrl: user.profilePhoto ?? "https://images.unsplash.com/photo-1599566150163-29194dcaad36?auto=format&fit=crop&w=800&q=80",
                          );
                        },
                        onStackFinished: () {
                          setState(() {
                             _swipeItems.clear();
                          });
                        },
                        itemChanged: (SwipeItem item, int index) {},
                        upSwipeAllowed: false,
                        fillSpace: true,
                      ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton(
                    heroTag: "btn_pass",
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.close, color: Colors.red, size: 30),
                    onPressed: _isLoading || _swipeItems.isEmpty ? null : () {
                      _matchEngine?.currentItem?.nope();
                    },
                  ),
                  FloatingActionButton(
                    heroTag: "btn_like",
                    backgroundColor: Theme.of(context).primaryColor,
                    child: const Icon(Icons.favorite, color: Colors.green, size: 30),
                    onPressed: _isLoading || _swipeItems.isEmpty ? null : () {
                      _matchEngine?.currentItem?.like();
                    },
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
