import 'package:flutter/material.dart';
import 'package:homepay/constants/colors_constants.dart';
import 'package:homepay/services/auth/auth_service.dart';
import 'package:homepay/services/cloud/collection/cloud_rewards.dart';
import 'package:homepay/services/cloud/collection/cloud_rewards_storage.dart';

class RewardView extends StatefulWidget {
  const RewardView({Key? key}) : super(key: key);

  @override
  State<RewardView> createState() => _RewardViewState();
}

class _RewardViewState extends State<RewardView> {
  late final CloudRewardsStorage _rewardService;

  @override
  void initState() {
    _rewardService = CloudRewardsStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.firebase().currentUser!;

    return StreamBuilder(
        stream: _rewardService.getRewards(userId: user.id),
        builder: ((context, snapshot) {
          // print(snapshot);
          switch (snapshot.connectionState) {
            case ConnectionState.active:
              final reward =
                  (snapshot.data as Iterable<CloudRewards>).elementAt(0);
              // print(reward.rewardsEarned);
              return RewardListView(reward: reward);
            default:
              return const Text('');
          }
        }));
  }
}

class RewardListView extends StatelessWidget {
  const RewardListView({Key? key, required this.reward}) : super(key: key);
  final CloudRewards reward;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: primaryColor,
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black,
                blurRadius: 2,
                spreadRadius: 1.5,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Wrap(children: [
            Column(children: [
              ListTile(
                title: const Text(
                  'Rewards Earned',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(
                    Icons.offline_bolt,
                    color: secondaryColor,
                  ),
                  const SizedBox(width: 10),
                  Text(reward.rewardsEarned.toString(),
                      style: const TextStyle(
                        fontSize: 18,
                        color: secondaryColor,
                      )),
                ]),
              ),
              ListTile(
                title: const Text(
                  'Rewards Used',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                trailing: Row(mainAxisSize: MainAxisSize.min, children: [
                  const Icon(
                    Icons.offline_bolt,
                    color: secondaryColor,
                  ),
                  const SizedBox(width: 10),
                  Text(reward.rewardsUsed.toString(),
                      style:
                          const TextStyle(fontSize: 18, color: secondaryColor)),
                ]),
              ),
            ]),
          ]),
        ),
        const SizedBox(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: primaryColor,
            boxShadow: const <BoxShadow>[
              BoxShadow(
                color: Colors.black,
                blurRadius: 2,
                spreadRadius: 1.5,
              ),
            ],
            borderRadius: BorderRadius.circular(8),
          ),
          child: const ListTile(
            leading: Icon(
              Icons.store,
              color: secondaryColor,
              size: 40,
            ),
            title: Text(
              'Store',
              style: TextStyle(
                  fontSize: 22,
                  color: secondaryColor,
                  fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              'Offers coming soon...',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
