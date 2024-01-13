import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_cubit.dart';
import 'package:jordan_insider/Controller/ShowAttractionCubit/show_attraction_state.dart';
import 'package:jordan_insider/Controller/UserDataCubit/user_data_cubit.dart';
import 'package:jordan_insider/Models/event.dart';
import 'package:jordan_insider/Shared/Constants.dart';

class BuyTicketScreen extends StatelessWidget {
  const BuyTicketScreen({super.key});
  static String route = "BuyTicketScreen";
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider.value(value: UserDataCubit.getInstans()),
        BlocProvider.value(value: ShowAttractionCubit.getInstans()),
      ],
      child: BlocConsumer<ShowAttractionCubit, ShowAttractionStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var attCubit = ShowAttractionCubit.getInstans();
          var userCubit = UserDataCubit.getInstans();
          SiteEvent event = attCubit.getAttraction() as SiteEvent;
          return Scaffold(
            appBar: myAppBar(),
            body: Container(
              margin: EdgeInsets.all(10.dg),
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      /*Name*/ Text(
                        event.getName(),
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      /*Image*/ SizedBox(
                        height: ScreenHeight(context) / 3,
                        child: Placeholder(
                          child: Image.memory(event.getImages().first!,
                              fit: BoxFit.cover),
                        ),
                      ),
                      Text(event.getDescription(),
                          style: TextStyle(fontSize: 15.sp)),
                      SizedBox(height: ScreenHeight(context) / 25),
                      /*Price*/ Row(
                        children: [
                          Text("Price : ",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              )),
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "${event.getPrice()} JOD",
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    margin: EdgeInsets.only(bottom: 15.dg),
                    child: Column(
                      children: [
                        ConditionalBuilder(
                          condition: attCubit.userTicket != null,
                          builder: (context) {
                            return Text("You already have 0 tickets");
                          },
                          fallback: null,
                        ),
                        DefaultButton(
                          gradientColor2: Color.fromARGB(255, 35, 120, 35),
                          gradientColor1: Color.fromARGB(255, 60, 180, 60),
                          width: ScreenWidth(context) / 2,
                          text: "Buy",
                          onPressed: () {
                            attCubit.buyTicket(
                              eventID: event.getID(),
                              userID: userCubit.userData!.getId(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
/**
 * {
  "ticketid": 0,
  "eventid": 0,
  "userid": 0
}
 */