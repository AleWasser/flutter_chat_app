import 'package:flutter/material.dart';

import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/models/user.dart';

class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  final users = [
    User(
      uid: '1',
      email: 'test@test.com',
      name: 'Test User',
      online: true,
    ),
    User(
      uid: '2',
      email: 'test@test2.com',
      name: 'Test User 2',
      online: true,
    ),
    User(
      uid: '3',
      email: 'test@test3.com',
      name: 'Test User 3',
      online: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'User Name',
          style: TextStyle(
            color: Colors.black54,
          ),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.exit_to_app,
            color: Colors.black54,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(
              right: 10,
            ),
            child: const Icon(
              Icons.check_circle,
              color: Colors.blue,
            ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _loadUsers,
        header: WaterDropHeader(
          complete: Icon(
            Icons.check,
            color: Colors.blue[400],
          ),
          waterDropColor: Colors.blue[400]!,
        ),
        child: _usersListView(),
      ),
    );
  }

  ListView _usersListView() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemBuilder: (_, index) => _userListTile(users[index]),
      separatorBuilder: (_, index) => const Divider(),
      itemCount: users.length,
    );
  }

  ListTile _userListTile(User user) {
    return ListTile(
      title: Text(user.name),
      subtitle: Text(user.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blue[100],
        child: Text(
          user.name.substring(0, 2),
        ),
      ),
      trailing: Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(
          color: user.online ? Colors.green : Colors.red,
          borderRadius: BorderRadius.circular(100),
        ),
      ),
    );
  }

  _loadUsers() async {
    await Future.delayed(const Duration(milliseconds: 1000));

    _refreshController.refreshCompleted();
  }
}
