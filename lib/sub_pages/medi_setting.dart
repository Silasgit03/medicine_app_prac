import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/sub_pages/caution_page.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../medicine_data/medicine.dart';
import '../util/utils.dart';
import 'info_page.dart';

class MedicineSettingPage extends StatefulWidget {
  final Medicine medicine;
  final bool creating;

  const MedicineSettingPage({
    Key? key,
    required this.medicine,
    required this.creating,
  }) : super(key: key);

  @override
  State<MedicineSettingPage> createState() => _MedicineSettingPageState();
}

class _MedicineSettingPageState extends State<MedicineSettingPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Medicine medicine;
  late String userEmail;
  late List<String> titleList = [
    "다음과 같은 효능이 있어요",
    "다음과 같이 사용해야 해요",
    "의약품 복용 전 참고하세요",
    "주의해야하는 사항이에요",
    "주의가 필요한 음식이에요",
    "이러한 부작용이 있어요",
    "다음과같이 보관해야 해요",
  ];
  late List<String> contentList = [
    medicine.effect,
    medicine.useMethod,
    medicine.warmBeforeHave,
    medicine.warmHave,
    medicine.interaction,
    medicine.sideEffect,
    medicine.depositMethod,
  ];

  // 데이터베이스에 약 추가
  Future<void> appendToArray(double fem) async {
    _firestore.collection(userEmail).doc('mediInfo').update({
      'medicine': FieldValue.arrayUnion([
        {
          'itemName': medicine.itemName,
          'entpName': medicine.entpName,
          'effect': medicine.effect,
          'itemCode': medicine.itemCode,
          'useMethod': medicine.useMethod,
          'warmBeforeHave': medicine.warmBeforeHave,
          'warmHave': medicine.warmHave,
          'interaction': medicine.interaction,
          'sideEffect': medicine.sideEffect,
          'depositMethod': medicine.depositMethod,
        }
      ])
    });
  }

  Future<void> removeToArray(dynamic element) async {
    _firestore.collection(userEmail).doc('mediInfo').update({
      'medicine': FieldValue.arrayRemove([element])
    });
  }

  void showAddOrRmvMessage(double fem) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "${medicine.itemName}을 ${widget.creating ? "추가" : "삭제"}했습니다.",
          textAlign: TextAlign.center,
          style: SafeGoogleFont(
            'Nunito',
            fontSize: 15 * fem,
            fontWeight: FontWeight.w400,
            height: 1.3625 * fem / fem,
            color: const Color(0xffffffff),
          ),
        ),
        backgroundColor: const Color(0xff8a60ff),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    medicine = widget.medicine;
    userEmail = _firebaseAuth.currentUser!.email!;
  }

  @override
  Widget build(BuildContext context) {
    double baseWidth = 380;
    double fem = MediaQuery.of(context).size.width / baseWidth;

    return Scaffold(
      backgroundColor: const Color(0xFFFCFCFC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA07EFF),
        centerTitle: true,
        actions: [
          // IconButton(
          //   onPressed: () async {
          //     widget.creating
          //         ? await appendToArray(fem)
          //         : await removeToArray({
          //             'itemName': medicine.itemName,
          //             'entpName': medicine.entpName,
          //             'effect': medicine.effect,
          //             'itemCode': medicine.itemCode,
          //             'useMethod': medicine.useMethod,
          //             'warmBeforeHave': medicine.warmBeforeHave,
          //             'warmHave': medicine.warmHave,
          //             'interaction': medicine.interaction,
          //             'sideEffect': medicine.sideEffect,
          //             'depositMethod': medicine.depositMethod,
          //           });
          //     if (!widget.creating) {
          //       await rmvAllAlarm();
          //     }
          //     showAddOrRmvMessage(fem);
          //     if (context.mounted) {
          //       Navigator.pop(context);
          //     }
          //     setState(() {});
          //   },
          //   icon: Icon(
          //     widget.creating ? Icons.add : Icons.playlist_remove,
          //     size: 35 * fem,
          //   ),
          // ),
          SizedBox(
            width: 10 * fem,
          ),
        ],
        elevation: 0,
        toolbarHeight: 80 * fem,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_sharp),
        ),
        title: AutoSizeText(
          medicine.itemName,
          textAlign: TextAlign.start,
          maxLines: 2,
          style: SafeGoogleFont(
            'Poppins',
            fontSize: 20 * fem,
            fontWeight: FontWeight.w600,
            color: const Color(0xffffffff),
          ),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(
            30 * fem,
            20 * fem,
            30 * fem,
            20 * fem,
          ),
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(0, 10*fem, 0, 10*fem),
                width: double.infinity,
                height: 195 * fem,
                child: Stack(
                  children: [
                    SizedBox(
                      width: 324 * fem,
                      height: 195 * fem,
                      child: Image.asset(
                        'image/group-842-eqt.png',
                        width: 324 * fem,
                        height: 195 * fem,
                      ),
                    ), // 배경
                    Container(
                      margin: EdgeInsets.fromLTRB(
                          20 * fem, 20 * fem, 20 * fem, 20 * fem),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 50 * fem,
                                    height: 50 * fem,
                                    decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.circular(18 * fem),
                                      color: const Color(0xffffffff),
                                    ),
                                    child: Center(
                                      child: Text(
                                        'UI',
                                        textAlign: TextAlign.center,
                                        style: SafeGoogleFont(
                                          'Poppins',
                                          fontSize: 16 * fem,
                                          fontWeight: FontWeight.w700,
                                          height: 1.5 * fem,
                                          color: const Color(0xffa07eff),
                                        ),
                                      ),
                                    ),
                                  ), // UI BOX 위젯
                                  SizedBox(width: 10 * fem),
                                  SizedBox(
                                    width: 120 * fem,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          medicine.itemName,
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 16 * fem,
                                            fontWeight: FontWeight.w700,
                                            height: 1.5 * fem,
                                            color: const Color(0xffffffff),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          medicine.entpName,
                                          style: SafeGoogleFont(
                                            'Poppins',
                                            fontSize: 12 * fem,
                                            fontWeight: FontWeight.w600,
                                            height: 1.5 * fem,
                                            color: const Color(0xffffffff),
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ), // 약 이름, 회사
                                ],
                              ), // UI BOX, 약 이름, 회사
                              InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CautionPage(
                                      medicine: medicine,
                                    ),
                                  ),
                                ),
                                child: Container(
                                  width: 90 * fem,
                                  height: 30 * fem,
                                  decoration: BoxDecoration(
                                    color: const Color(0xffffffff),
                                    borderRadius:
                                        BorderRadius.circular(99 * fem),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '주의사항',
                                      textAlign: TextAlign.center,
                                      style: SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 14 * fem,
                                        fontWeight: FontWeight.w800,
                                        height: 1.5 * fem,
                                        color: const Color(0xffa98aff),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ), // UI BOX and 주의사항
                          SizedBox(height: 5 * fem),
                          AutoSizeText(
                            medicine.effect,
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                            style: SafeGoogleFont(
                              'Poppins',
                              fontSize: 16 * fem,
                              fontWeight: FontWeight.w700,
                              height: 1.5,
                              color: const Color(0xffffffff),
                            ),
                          ), // 약 설명
                        ],
                      ),
                    ), // 배경 위 위젯
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: 7,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      padding: EdgeInsets.only(bottom: 20 * fem),
                      child: Stack(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Image.asset(
                              'image/causionbox.png',
                            ),
                          ), // 배경
                          Container(
                            margin: EdgeInsets.fromLTRB(
                                20 * fem, 20 * fem, 20 * fem, 0 * fem),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      titleList[index],
                                      style: SafeGoogleFont(
                                        'Poppins',
                                        fontSize: 16 * fem,
                                        fontWeight: FontWeight.w700,
                                        height: 1.5 * fem,
                                        color: const Color(0xffffffff),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => InfoPage(
                                            title: titleList[index],
                                            content: contentList[index],
                                          ),
                                        ),
                                      ),
                                      child: Container(
                                        width: 90 * fem,
                                        height: 30 * fem,
                                        decoration: BoxDecoration(
                                          color: const Color(0xffffffff),
                                          borderRadius:
                                              BorderRadius.circular(99 * fem),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "자세히보기",
                                            textAlign: TextAlign.center,
                                            style: SafeGoogleFont(
                                              'Poppins',
                                              fontSize: 14 * fem,
                                              fontWeight: FontWeight.w800,
                                              height: 1.5 * fem,
                                              color: const Color(0xffa98aff),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ), // UI BOX and 주의사항
                                SizedBox(height: 10 * fem),
                                Text(
                                  contentList[index],
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: SafeGoogleFont(
                                    'Poppins',
                                    fontSize: 16 * fem,
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                    color: const Color(0xffffffff),
                                  ),
                                ), // 약 설명
                              ],
                            ),
                          ), // 배경 위 위젯
                        ],
                      ),
                    );
                  },
                ),
              )
              // if (!widget.creating)
              //   Expanded(
              //     child: Center(
              //       child: alarms.isNotEmpty
              //           ? ListView.separated(
              //               itemCount: alarms.length,
              //               padding: EdgeInsets.only(top: 5 * fem),
              //               separatorBuilder: (context, index) =>
              //                   const Divider(),
              //               itemBuilder: (context, index) {
              //                 return AlarmTile(
              //                   key: Key(alarms[index].id.toString()),
              //                   time: TimeOfDay(
              //                     hour: alarms[index].dateTime.hour,
              //                     minute: alarms[index].dateTime.minute,
              //                   ).format(context),
              //                   onPressed: () =>
              //                       navigateToAlarmScreen(alarms[index]),
              //                   // edit 페이지로 이동하는 함수 호출
              //                   onDismissed: () {
              //                     Alarm.stop(alarms[index].id)
              //                         .then((_) => loadAlarms());
              //                   },
              //                   name: medicine.itemName,
              //                   company: medicine.entpName,
              //                 ); // 알람 타일,
              //               },
              //             )
              //           : Text(
              //               "No alarms set",
              //               style: Theme.of(context).textTheme.titleMedium,
              //             ),
              //     ),
              //   ), // 알람 리스트
            ],
          ),
        ),
      ),
    );
  }
}

class DayWidget extends StatefulWidget {
  final String day;
  final double fem;

  const DayWidget({super.key, required this.fem, required this.day});

  @override
  State<DayWidget> createState() => _DayWidgetState();
}

class _DayWidgetState extends State<DayWidget> {
  bool isSelected = false;
  late String day;
  late double fem;

  @override
  void initState() {
    super.initState();
    day = widget.day;
    fem = widget.fem;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
        });
      },
      child: Container(
        width: 40 * widget.fem,
        height: 50 * widget.fem,
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xffa07eff) : const Color(0xffDFD3FF),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Center(
          child: Text(
            widget.day,
            style: SafeGoogleFont(
              'Poppins',
              fontSize: 16 * widget.fem,
              fontWeight: FontWeight.w500,
              height: 1.5 * widget.fem,
              color: const Color(0xffffffff),
            ),
          ),
        ),
      ),
    );
  }
}
