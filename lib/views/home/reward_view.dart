import 'package:flutter/material.dart';
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
    return Column(children: [
      ListTile(
        title: const Text(
          'Rewards Earned',
          style: TextStyle(fontSize: 18),
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.local_atm),
          const SizedBox(width: 10),
          Text(reward.rewardsEarned.toString(),
              style: const TextStyle(fontSize: 18)),
        ]),
      ),
      ListTile(
        title: const Text(
          'Rewards Used',
          style: TextStyle(fontSize: 18),
        ),
        trailing: Row(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.local_atm),
          const SizedBox(width: 10),
          Text(reward.rewardsUsed.toString(),
              style: const TextStyle(fontSize: 18)),
        ]),
      )
    ]);
  }
}
