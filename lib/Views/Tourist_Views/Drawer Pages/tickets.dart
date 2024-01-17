// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/TicketCubit/ticket_cubit.dart';
import 'package:jordan_insider/Controller/TicketCubit/ticket_state.dart';
import 'package:jordan_insider/Models/ticket.dart';
import 'package:jordan_insider/Shared/Constants.dart';

// ignore: must_be_immutable
class Tickets extends StatelessWidget {
  Tickets({super.key});
  static String route = "Tickets";
  bool getTicketFirstTime = true;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: TicketCubit.getInstans(),
      child: BlocConsumer<TicketCubit, TicketStates>(
          listener: (context, state) {},
          builder: (context, state) {
            var cubit = TicketCubit.getInstans();
            if (getTicketFirstTime) {
              cubit.getAllTickets();
              getTicketFirstTime = false;
            }
            return Scaffold(
              appBar: myAppBar(
                title: Text("My Tickets"),
              ),
              body: ListView.builder(
                itemCount: cubit.tickets.length,
                itemBuilder: (context, index) =>
                    ticketCard(cubit.tickets[index]),
              ),
            );
          }),
    );
  }

  Widget ticketCard(Ticket tic) {
    return Dismissible(
      background: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.dg),
        margin: EdgeInsets.only(top: 10.dg),
        color: Colors.red,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(
              Icons.delete_forever,
              color: Colors.white,
              size: 25.sp,
            ),
            Icon(
              Icons.delete_forever,
              color: Colors.white,
              size: 25.sp,
            ),
          ],
        ),
      ),
      key: Key(tic.getTicketID().toString()),
      onDismissed: (e) {
        TicketCubit.getInstans().deleteTicket(tic.getTicketID());
      },
      child: Card(
        borderOnForeground: true,
        elevation: 5,
        margin: EdgeInsets.only(top: 10.dg, right: 10.dg, left: 10.dg),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 7.5.dg),
          alignment: Alignment.centerLeft,
          height: 75.h,
          child: Text(tic.getEvent()!.name, style: TextStyle(fontSize: 20.sp)),
        ),
      ),
    );
  }
}
