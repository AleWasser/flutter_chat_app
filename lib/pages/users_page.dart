import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/models/user.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/users_service.dart';
import 'package:chat_app/services/socket_service.dart';

class UsersPage extends StatefulWidget {
  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final userService = UsersService();

  List<User> users = [];

  @override
  void initState() {
    _loadUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          authService.user.name,
          style: const TextStyle(
            color: Colors.black54,
          ),
        ),
        elevation: 1,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            socketService.disconnect();
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
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
            child: socketService.serverStatus == ServerStatus.Online
                ? const Icon(
                    Icons.check_circle,
                    color: Colors.blue,
                  )
                : const Icon(
                    Icons.offline_bolt,
                    color: Colors.red,
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
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.targetUser = user;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }

  _loadUsers() async {
    users = await userService.getUsers();
    setState(() {});

    _refreshController.refreshCompleted();
  }
}
