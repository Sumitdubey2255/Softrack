
/*

Author: Sumit Sunil Dubey
location: Thane
link: https://sumit-portfolio-4mn0.onrender.com/

*/
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../JsonModels/comp_details.dart';
import '../../../JsonModels/create_comp.dart';
import '../../../JsonModels/size_option_item.dart';
import '../../../JsonModels/size_options_model.dart';
import '../../../constants/app_colors.dart';
import '../../../core/components/app_back_button.dart';
import '../../../supabase/supabase.dart';
import '../utils/validators.dart';

class CompCardDetailsPage extends StatefulWidget {
  final CreateComp? usersData;
  const CompCardDetailsPage({super.key, this.usersData});

  @override
  State<CompCardDetailsPage> createState() => _CompCardDetailsPageState();
}

final db = SupaBaseDatabaseHelper();

class _CompCardDetailsPageState extends State<CompCardDetailsPage> {
  int? selectedSize; // Start with no selection
  List<CompDetails> compDetails = [];
  String days = "0";
  String activeStatus = "";
  late Future<List<CreateComp>> compData;

  final db = SupaBaseDatabaseHelper();
  late SupaBaseDatabaseHelper handler;
  final name = TextEditingController();
  final shopName = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();
  final compKey = TextEditingController();
  final startDate = TextEditingController();
  final previousServicesDay = TextEditingController();
  final endDate = TextEditingController();
  final userCount = TextEditingController();
  final daysExtend = TextEditingController();
  final daysCount = TextEditingController();
  final amount = TextEditingController();
  final List<String> yrItems = ['Default', '1 month', '2 months', '3 months', '6 months', '8 months', '1 year'];
  final List<String> userItems = ['1 admin 0 user', '1 admin 1 user', '1 admin 2 user', '1 admin 3 user', '1 admin 4 user'];
  final List<String> serviceItems = ['Free Trial', 'Subscription'];
  String? _selectedServiceDays;
  String? _selectedServiceType;
  String? _selectedAccountsAllowed;

  String? dropdownValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select a value';
    }
    return null;
  }

  void _handleServiceDaysChange(String? value) {
    setState(() {
      _selectedServiceDays = value;
      switch (value) {
        case '1 month':
          daysCount.text = "30 Days";
          break;
        case '2 months':
          daysCount.text = "60 Days";
          break;
        case '3 months':
          daysCount.text = "90 Days";
          break;
        case '6 months':
          daysCount.text = "180 Days";
          break;
        case '8 months':
          daysCount.text = "240 Days";
          break;
        case '1 year':
          daysCount.text = "360 Days";
          break;
        default:
          daysCount.text = "30 Days";
      }
    });
  }

  String _dayCount(CreateComp userData) {
    String totalDays = userData.usrNoOfDays;
    List<String> parts = totalDays.split('/');
    if (parts.length == 4) {
      days = "${parts[0]}/${parts[1]}"; // 06/90
    } else if (parts.length == 3) {
      days = "00/${parts[0]}"; // 00/90
    } else if (parts.length == 2) {
      days = "00/${parts[0]}"; // 00/90
    } else {
      days = '0';
    }
    return days;
  }

  String _daysRem(CreateComp userData) {
    String totalDays = userData.usrNoOfDays;
    DateTime currentDate = DateTime.now();
    String datee = userData.createdAt.split("/").length > 1 ? userData.createdAt.split("/")[0] : userData.createdAt;
    DateTime createdAtDate = DateTime.parse(datee);
    int daysSpent = currentDate.difference(createdAtDate).inDays;
    int spent = 0, days = 0;
    List<String> parts = totalDays.split('/');
    if (parts.length == 2) {
      days = int.tryParse(parts[0]) ?? 0;
      spent = 0;
    } else if (parts.length == 3) {
      spent = 0;
      days = int.tryParse(parts[0]) ?? 0;
    } else if (parts.length == 4) {
      spent = int.tryParse(parts[0]) ?? 0;
      days = int.tryParse(parts[1]) ?? 0;
    }
    int remainingDays = (days + 5) - daysSpent;
    String mess = remainingDays < 0 ? "$days Days plan has ended." : "$remainingDays Days remaining!";
    return mess;
  }

  String _status(CreateComp userData) {
    String totalDays = userData.usrNoOfDays;
    List<String> parts = totalDays.split('/');
    if (parts.length == 2) {
      activeStatus = "${parts[1]}/0"; // "active"
    } else if (parts.length == 3) {
      activeStatus = "${parts[1]}/${parts[2]}"; // "active"
    } else if (parts.length == 4) {
      activeStatus = "${parts[2]}/${parts[3]}"; // "active/02"
    } else {
      activeStatus = '';
    }
    return activeStatus; // "active/0"
  }

  String _formatAadhaar(String aadhaarNo) {
    if (aadhaarNo.length == 16) {
      return "xxxx xxxx xxxx ${aadhaarNo.substring(12)}";
    } else if (aadhaarNo.length > 14) {
      return "xxxx xxxx xxxx ${aadhaarNo.substring(aadhaarNo.length - 4)}";
    } else {
      return aadhaarNo;
        }
  }

  void _resume(CreateComp userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Resume Service'),
          content: const Text('Are you sure you want to resume the service?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // execution-------------------------------------------------------------------------------------------------
                DateTime currentDate = DateTime.now();
                DateTime createdAtDate = DateTime.parse(userData.createdAt.split("/")[1]); //paused date
                int daysSpent = currentDate.difference(createdAtDate).inDays;
                String sta = _status(userData).split("/")[0] != "active" ? 'active' : 'pause';
                int pre = int.tryParse(_status(userData).split("/")[1]) ?? 0;
                db.updateService(
                    userData.usrId,
                    "${_dayCount(userData)}/$sta/${_status(userData).split("/")[1]}", // "02/90/pause/0"
                    userData.createdAt.split("/")[0]
                ).whenComplete(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Service Resumed. You need to reload the page.')),
                  );
                });
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _pause(CreateComp userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pause Service'),
          content: const Text('Are you sure you want to pause the service?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                // execution-----------------------------------------------------------------------------------
                String sta = _status(userData).split("/")[0] == "active" ? 'pause': 'active';
                // print("${_dayCount()}/$sta/${_status().split("/")[1]}");
                db.updateService(
                  userData.usrId,
                  "${_dayCount(userData)}/$sta/${_status(userData).split("/")[1]}", // "02/90/pause/0"
                  "${userData.createdAt}/${DateTime.now().toIso8601String()}",  // Fix here
                ).whenComplete(() {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Service Paused. You need to reload the page.')),
                  );
                });
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  Future<List<CreateComp>> getCompData() {
    return handler.getCompData(widget.usersData!.usrName, widget.usersData!.usrPhone); // Fetch notes for the current user
  }

  Future<void> _refresh() async {
    setState(() {
      compData = getCompData();
    });
  }
  @override
  void initState() {
    handler = SupaBaseDatabaseHelper();
    compData = getCompData(); // Fetch notes for the current user
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CreateComp>>(
        future: compData,
        builder: (BuildContext context, AsyncSnapshot<List<CreateComp>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error fetching data.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available.'));
          } else {
            CreateComp userData = snapshot.data!.first; // Assuming you're using the first entry
            return ListView(
              padding: EdgeInsets.zero,
              children: [
                AppBar(
                  leading: const AppBackButton(),
                  title: const Text('Details'),
                  titleTextStyle: const TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF5DE0E6), // First color
                          Color(0xFF0078A6), // Second color
                        ],
                        begin: Alignment.topLeft, // Adjust the gradient direction as needed
                        end: Alignment.bottomRight, // Adjust the gradient direction as needed
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF5DE0E6), // First color
                        Color(0xFF0078A6), // Second color
                      ],
                      begin: Alignment.topLeft, // Adjust the gradient direction as needed
                      end: Alignment.bottomRight, // Adjust the gradient direction as needed
                    ),
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(70),
                    ),
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF5DE0E6), // First color
                          Color(0xFF0078A6), // Second color
                        ],
                        begin: Alignment.topLeft, // Adjust the gradient direction as needed
                        end: Alignment.bottomRight, // Adjust the gradient direction as needed
                      ),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(70),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            const SizedBox(width: 30),
                            Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 5.0),
                                  ),
                                  child: SizedBox(
                                    width: 90,
                                    height: 90,
                                    child: ClipOval(
                                      child: AspectRatio(
                                        aspectRatio: 1 / 1,
                                        child: Image.asset(
                                          'lib/assets/keepveda.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Container(
                                  alignment: Alignment.center,
                                  width: 80,
                                  padding: const EdgeInsets.all(1.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _status(userData).split("/")[0] == "active" ? const Color(0xFF00FF94) : Colors.red, // Conditional border color
                                      width: 2.0,
                                    ),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text(
                                    _status(userData).split("/")[0] == "active" ? "Active" : "Paused", // Correct text based on the status
                                    style: const TextStyle(fontSize: 15, color: Colors.white),
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(width: 20),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 180,
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white60, width: 2.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text(
                                    'Name: ${userData.usrName}',
                                    style: const TextStyle(fontSize: 15, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Container(
                                  width: 180,
                                  padding: const EdgeInsets.all(4.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white60, width: 2.0),
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Text(
                                    'Shop: ${userData.usrShopName}',
                                    style: const TextStyle(fontSize: 15, color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(Icons.date_range_sharp, color: Colors.white, size: 25),
                                    const SizedBox(width: 8.0),
                                    Container(
                                      // width: 186,
                                      padding: const EdgeInsets.all(4.0),
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.white60, width: 2.0),
                                        borderRadius: BorderRadius.circular(5.0),
                                      ),
                                      child: Text(
                                        DateFormat("dd/MM/yyyy").format(
                                            DateTime.parse(
                                                userData.createdAt.split("/").length > 1 ? userData.createdAt.split("/")[0] : userData.createdAt
                                            )
                                        ),
                                        style: const TextStyle(fontSize: 15, color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: const Color(0xFF5EC4D7),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(70)),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(sizeOptions.length, (index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedSize = index; // Update selected index
                                });
                              },
                              child: SizeOptionItem(
                                index: index,
                                selected: selectedSize == index,
                                sizeOption: sizeOptions[index],
                                contactDetail: index == 0 || index == 1 || index == 3 ? userData.usrPhone : userData.usrEmail,
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 10),
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    offset: const Offset(0, 5),
                                    color: Theme.of(context).primaryColor.withOpacity(.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  // child: items('Address', "${userData.usrShopName}, ${userData.usrAddress}\n\nAadhaar No.: ${_formatAadhaar(userData.usrAadharNo)}", Colors.deepOrange),
                                  child: items('Address', "${userData.usrShopName}, ${userData.usrAddress}\n\nAadhaar No.: ${userData.usrAadharNo}", Colors.deepOrange),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30), // Space between the rows
                          ],
                        ),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left:5,bottom: 10, right: 5),
                          child: Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 5),
                                      color: Theme.of(context).primaryColor.withOpacity(.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const SizedBox(height: 5),
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      width: 110,
                                      height: 60,
                                      margin: const EdgeInsets.all(10),
                                      decoration: const BoxDecoration(
                                        color: Colors.blueGrey,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(CupertinoIcons.profile_circled, color: Colors.white, size: 45,),
                                    ),
                                    Center(
                                      child: Text('${userData.usrUsersCount.split(" ")[2]} users',
                                          style: Theme.of(context).textTheme.titleSmall),
                                    ),
                                    Text('Accounts',
                                        style: Theme.of(context).textTheme.titleSmall),
                                    const SizedBox(height: 4),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      offset: const Offset(0, 5),
                                      color: Theme.of(context).primaryColor.withOpacity(.2),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    const SizedBox(height: 15),
                                    Row(
                                      children: [
                                        const Icon(Icons.contact_page_outlined, color: Color(0xFF5EC4D7), size: 18),
                                        const SizedBox(width: 5.0),
                                        Text('Contacts', style: Theme.of(context).textTheme.titleMedium),
                                      ],
                                    ),
                                    Container(
                                      width: 190,
                                      height: 60,
                                      margin: const EdgeInsets.all(10),
                                      child: Column(
                                        children: [
                                          const SizedBox(height: 9),
                                          Row(
                                            children: [
                                              const Icon(Icons.phone, color: Color(0xFF5EC4D7), size: 21),
                                              const SizedBox(width: 5.0),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(
                                                    userData.usrPhone,
                                                    style: const TextStyle(fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16.0),
                                            ],
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            children: [
                                              const Icon(Icons.mail_outline, color: Color(0xFF5EC4D7), size: 21),
                                              const SizedBox(width: 5.0),
                                              Expanded(
                                                child: SingleChildScrollView(
                                                  scrollDirection: Axis.horizontal,
                                                  child: Text(
                                                    userData.usrEmail,
                                                    style: const TextStyle(fontSize: 15),
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 16.0),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(left:5,bottom: 10, right: 5),
                          child:Row(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(0, 5),
                                        color: Theme.of(context).primaryColor.withOpacity(.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          const Icon(Icons.account_tree_outlined, color: Color(
                                              0xBD08FC00), size: 19),
                                          const SizedBox(width: 10.0),
                                          Text('Service Details',style: Theme.of(context).textTheme.titleMedium,),
                                        ],
                                      ),
                                      Container(
                                          margin: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              const SizedBox(height: 2),
                                              Row(
                                                children: [
                                                  const Icon(Icons.add_chart_rounded, color: Color(0xFF5EC4D7), size: 21),
                                                  const SizedBox(width: 5.0),
                                                  Text('Service Type: ${userData.usrServiceType}', style: const TextStyle(fontSize: 14)),
                                                  const SizedBox(width: 16.0),
                                                ],
                                              ),
                                              const SizedBox(height: 4),
                                              Row(
                                                children: [
                                                  const Icon(Icons.access_time, color: Color(0xFF04CB49), size: 21),
                                                  const SizedBox(width: 5.0),
                                                  Text('Duration: ${_dayCount(userData).split("/")[1]} Days', style: const TextStyle(fontSize: 14)),
                                                  const SizedBox(width: 16.0),
                                                ],
                                              ),
                                              const SizedBox(height: 5),
                                              Row(
                                                children: [
                                                  const Icon(Icons.currency_rupee_outlined, color: Color(0xFF5EC4D7), size: 21),
                                                  const SizedBox(width: 5.0),
                                                  Text('Paid Amount: ${userData.usrPaidAmt}/-', style: const TextStyle(fontSize: 14)),
                                                  const SizedBox(width: 16.0),
                                                ],
                                              ),
                                            ],
                                          )
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        offset: const Offset(0, 5),
                                        color: Theme.of(context).primaryColor.withOpacity(.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 3),
                                      Container(
                                        padding: const EdgeInsets.all(10),
                                        width: 90,
                                        margin: const EdgeInsets.all(10),
                                        decoration: const BoxDecoration(
                                          color: Colors.blueGrey,
                                          shape: BoxShape.circle,
                                        ),
                                        child: const Icon(CupertinoIcons.app_badge_fill, color: Colors.white, size: 40,),
                                      ),
                                      Text('Day Count',
                                          style: Theme.of(context).textTheme.titleMedium),
                                      Center(
                                        child: Text("${_dayCount(userData)} Days",
                                            style: Theme.of(context).textTheme.titleMedium),
                                      ),
                                      const SizedBox(height: 4),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  if(_status(userData).split("/")[0]=="active"){
                                    _pause(userData);
                                  }else{
                                    _resume(userData);
                                  }
                                  _refresh();
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                                  decoration: BoxDecoration(
                                      color: _status(userData).split("/")[0] == "active" ? const Color(
                                          0xDDF31212): const Color(0xFF05A462),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: Center(
                                    child: Text(
                                      _status(userData).split("/")[0] == "active" ?'Pause Service': 'Resume Plan',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            Expanded(
                              child: GestureDetector(
                                onTap: () {
                                    setState(() {
                                      name.text = userData.usrName;
                                      shopName.text = userData.usrShopName;
                                      email.text = userData.usrEmail;
                                      phone.text = userData.usrPhone;
                                      daysCount.text = "${_dayCount(userData).split("/")[1]} Days";
                                      _selectedServiceType = userData.usrServiceType;
                                      print(userData.usrServiceType);
                                    _selectedAccountsAllowed = userData.usrUsersCount;
                                    });
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          actions: [
                                            Row(
                                              children: [
                                                TextButton(
                                                  onPressed: () {
                                                    db.upGradeService(
                                                        userData.usrId,
                                                        _dayCount(userData), // 95/90
                                                        _status(userData).split("/")[0] == "active" ?'pause': 'active',
                                                        userData.usrPaidAmt, //previously paid amt
                                                        CreateComp(
                                                          usrUserName: userData.usrUserName,
                                                          usrName: name.text,
                                                          usrShopName: shopName.text,
                                                          usrPhone: phone.text,
                                                          usrEmail: userData.usrEmail,
                                                          usrCompKey: compKey.text,
                                                          usrAppName: "KeepVeda",
                                                          usrServiceType: _selectedServiceType.toString(),
                                                          usrUsersCount: _selectedAccountsAllowed.toString(),
                                                          usrPayType: userData.usrPayType,
                                                          usrAadharNo: userData.usrAadharNo,
                                                          usrPaidAmt: amount.text, //new paid amount
                                                          usrNoOfDays: daysCount.text.replaceAll(' Days', '/active/0'), // daysCount.text,
                                                          usrDeploymentType: "Offline",
                                                        )
                                                    ).whenComplete(() {
                                                      _refresh();
                                                      Navigator.pop(context);
                                                    });
                                                  },
                                                  child: const Text("Update"),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(context);
                                                  },
                                                  child: const Text("Cancel"),
                                                ),
                                              ],
                                            ),
                                          ],
                                          title: const Text("Upgrade Service"),
                                          content: SingleChildScrollView(
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  _daysRem(userData),
                                                  style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Color(0xC24F5050),
                                                  ),
                                                ),
                                                const SizedBox(height: 15),
                                                TextFormField(
                                                  controller: name,
                                                  enabled: false,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Name is required";
                                                    }
                                                    return null;
                                                  },
                                                  decoration: const InputDecoration(
                                                    label: Text("Name"),
                                                    hintText: "Enter Your Name",
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                TextFormField(
                                                  controller: shopName,
                                                  enabled: false,
                                                  validator: (value) {
                                                    if (value!.isEmpty) {
                                                      return "Shop name is required";
                                                    }
                                                    return null;
                                                  },
                                                  decoration: const InputDecoration(
                                                    label: Text("Shop Name"),
                                                    hintText: "Enter Your Shop Name",
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                TextFormField(
                                                  controller: email,
                                                  enabled: false,
                                                  validator: Validators.email.call,
                                                  decoration: const InputDecoration(
                                                    label: Text("Email"),
                                                    hintText: "Enter Your Email",
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                TextFormField(
                                                  controller: phone,
                                                  enabled: false,
                                                  validator: Validators.phone.call,
                                                  decoration: const InputDecoration(
                                                    label: Text("Phone"),
                                                    hintText: "Enter Your Phone Number",
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                DropdownButtonFormField<String>(
                                                  decoration: const InputDecoration(
                                                    labelText: "Service Type",
                                                  ),
                                                  value: _selectedServiceType,
                                                  items: serviceItems.map((String item) {
                                                    return DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(item),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selectedServiceType = value;
                                                    });
                                                  },
                                                  validator: dropdownValidator,
                                                ),
                                                const SizedBox(height: 10),
                                                DropdownButtonFormField<String>(
                                                  decoration: const InputDecoration(
                                                    labelText: "Plan Period",
                                                  ),
                                                  value: _selectedServiceDays,
                                                  items: yrItems.map((String item) {
                                                    return DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(item),
                                                    );
                                                  }).toList(),
                                                  onChanged: _handleServiceDaysChange,
                                                  validator: dropdownValidator,
                                                ),
                                                const SizedBox(height: 10),
                                                DropdownButtonFormField<String>(
                                                  decoration: const InputDecoration(
                                                    labelText: "Accounts Allowed",
                                                  ),
                                                  value: _selectedAccountsAllowed,
                                                  items: userItems.map((String item) {
                                                    return DropdownMenuItem<String>(
                                                      value: item,
                                                      child: Text(item),
                                                    );
                                                  }).toList(),
                                                  onChanged: (value) {
                                                    setState(() {
                                                      _selectedAccountsAllowed = value;
                                                    });
                                                  },
                                                  validator: dropdownValidator,
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: TextFormField(
                                                        controller: amount,
                                                        validator: Validators.requiredWithFieldName('Amount').call,
                                                        keyboardType: TextInputType.number,
                                                        decoration: const InputDecoration(
                                                          label: Text("Amount"),
                                                          hintText: "₹0.0",
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                        child: TextFormField(
                                                          controller: daysCount,
                                                          validator: Validators.requiredWithFieldName('Days').call,
                                                          keyboardType: TextInputType.number,
                                                          decoration: const InputDecoration(
                                                            label: Text("No.of Days"),
                                                            hintText: "0 Days",
                                                          ),
                                                        ),
                                                    )
                                                  ]
                                                ),
                                                const SizedBox(height: 10),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
                                  decoration: BoxDecoration(
                                      color: const Color(0xE8C54404),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: const Center(
                                    child: Text(
                                      'Upgrade Service',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Forget ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                  context: context,
                                    builder: (BuildContext context) {
                                      String phoneNumber = userData.usrPhone;
                                      String formattedCode = 'KV${phoneNumber.substring(0, 2)}${phoneNumber.substring(phoneNumber.length - 2)}';
                                      String message = "Your password to open AuthKey Card provided by Typical Desktop Team is \"$formattedCode\".\nDo not disclose this to anyone.\nThanks for being with us!\n\n\nWeb- https://typicaldesktop.com";
                                      return AlertDialog(
                                          title: const Text('Forget Alert!!!'),
                                          content: Text('They have already received AuthKey Card on there Registered Email.\nHere is an password which helps to open authCard.\nPassCode: $formattedCode'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              child: const Text('OK'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                final Uri smsUri = Uri(
                                                  scheme: 'sms',
                                                  path: phoneNumber,
                                                  queryParameters: {'body': message},
                                                );
                                                if (await canLaunchUrl(smsUri)) {
                                                  await launchUrl(smsUri);
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Could not send SMS.')),
                                                  );
                                                }
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              child: const Text('Send SMS'),
                                            ),
                                          ]
                                      );
                                    }
                                );
                              },
                              child: Text(
                                'Username ',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Text(
                              'OR ',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      String phoneNumber = userData.usrPhone;
                                      String formattedCode = 'KV${phoneNumber.substring(0, 2)}${phoneNumber.substring(phoneNumber.length - 2)}';
                                      String message = "Your password to open AuthKey Card provided by Typical Desktop Team is \"$formattedCode\".\nDo not disclose this to anyone.\nThanks for being with us!\n\n\nWeb- https://typicaldesktop.com";
                                      return AlertDialog(
                                          title: const Text('Forget Alert!!!'),
                                          content: Text('They have already received AuthKey Card on there Registered Email.\nHere is an password which helps to open authCard.\nPassCode: $formattedCode'),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              child: const Text('OK'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                final Uri smsUri = Uri(
                                                  scheme: 'sms',
                                                  path: phoneNumber,
                                                  queryParameters: {'body': message},
                                                );
                                                if (await canLaunchUrl(smsUri)) {
                                                  await launchUrl(smsUri);
                                                } else {
                                                  ScaffoldMessenger.of(context).showSnackBar(
                                                    const SnackBar(content: Text('Could not send SMS.')),
                                                  );
                                                }
                                                Navigator.of(context).pop(); // Close the dialog
                                              },
                                              child: const Text('Send SMS'),
                                            ),
                                          ]
                                      );
                                    }
                                );
                              },
                              child: Text(
                                'Password',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                            Text(
                              '??',
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  itemDashboard(String title, IconData iconData, Color background) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 5),
          color: Theme.of(context).primaryColor.withOpacity(.2),
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: background,
            shape: BoxShape.circle,
          ),
          child: Icon(iconData, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Text(title.toUpperCase(),
            style: Theme.of(context).textTheme.titleMedium),
      ],
    ),
  );

  items(String title, String text, Color background) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(
          offset: const Offset(0, 5),
          color: Theme.of(context).primaryColor.withOpacity(.2),
          spreadRadius: 2,
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 15),
        Row(
          children: [
            const SizedBox(width: 10.0),
            const Icon(Icons.location_on_outlined, color: Color(0xFF5EC4D7), size: 18),
            const SizedBox(width: 5.0),
            Text(title.toUpperCase(),style: Theme.of(context).textTheme.titleMedium,),
          ],
        ),
        Container(
          width: 285,
          // height: 100,
          margin: const EdgeInsets.all(10),
          child: Text(text),
        ),
        const SizedBox(height: 15),
      ],
    ),
  );
}
