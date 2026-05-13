import 'package:flutter/material.dart';

import '../helpers/api_helpers.dart';

class BudgetManagementPage extends StatefulWidget {
  final int userId;
  const BudgetManagementPage({super.key, required this.userId});

  @override
  State<BudgetManagementPage> createState() => _BudgetManagementPageState();
}

class _BudgetManagementPageState extends State<BudgetManagementPage> {
  List budgets = [];
  List categories = [];

  @override
  void initState() {
    super.initState();
    loadBudgets();
  }

  Future<void> loadBudgets() async {
    budgets = await ApiHelpers.getBudgets(widget.userId);
    categories = await ApiHelpers.getCategories();
    setState(() {});
  }

  String getCategoryName(int categoryId) {
    var category = categories.firstWhere(
          (c) => c['id'] == categoryId,
      orElse: () => {"name": "Khác"},
    );

    return category['name'];
  }

  @override
  Widget build(BuildContext context) {
    double totalBudget = 0;
    double totalSpent = 0;

    for (var b in budgets) {
      totalBudget += (b['amount'] ?? 0);
      totalSpent += (b['spent_amount'] ?? 0);
    }

    double totalPercent =
    totalBudget == 0 ? 0 : totalSpent / totalBudget;

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),

      appBar: AppBar(
        backgroundColor: const Color(0xffF5F7FB),
        elevation: 0,
        title: const Text(
          "Quản lý ngân sách",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// CARD TỔNG
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const Text(
                    "TỔNG NGÂN SÁCH",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [

                      Text(
                        "${totalBudget.toStringAsFixed(0)}đ",
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "ĐÃ CHI",
                            style: TextStyle(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            "${totalSpent.toStringAsFixed(0)}đ",
                            style: const TextStyle(
                              color: Colors.blue,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),

                  const SizedBox(height: 15),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: totalPercent,
                      minHeight: 10,
                      backgroundColor: Colors.blue.shade100,
                      valueColor:
                      const AlwaysStoppedAnimation(
                          Colors.blue),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Còn lại ${(totalBudget - totalSpent).toStringAsFixed(0)}đ",
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),

                      Text(
                        "${(totalPercent * 100).toStringAsFixed(0)}%",
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// HEADER
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [

                const Text(
                  "Các hạng mục",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                ElevatedButton.icon(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,

                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    loadBudgets();
                    /// mở dialog thêm budget
                    showAddBudgetDialog();
                  },

                  icon: const Icon(Icons.add),

                  label: const Text("Thêm mục"),
                )
              ],
            ),

            const SizedBox(height: 20),

            /// LIST BUDGET
            ListView.builder(
              itemCount: budgets.length,
              shrinkWrap: true,
              physics:
              const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {

                var b = budgets[index];

                double amount =
                (b['amount'] ?? 0).toDouble();

                double spent =
                (b['spent_amount'] ?? 0).toDouble();

                double remain = amount - spent;

                double percent =
                amount == 0 ? 0 : spent / amount;

                Color progressColor =
                percent >= 0.8
                    ? Colors.red
                    : percent >= 0.5
                    ? Colors.orange
                    : Colors.blue;

                String status =
                percent >= 0.8
                    ? "Sắp chạm ngưỡng"
                    : percent >= 0.5
                    ? "Trung bình"
                    : "An toàn";

                return Container(
                  margin:
                  const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                    BorderRadius.circular(18),
                  ),

                  child: Column(
                    children: [

                      Row(
                        children: [

                          CircleAvatar(
                            backgroundColor:
                            progressColor
                                .withOpacity(0.1),
                            child: Icon(
                              Icons.account_balance_wallet,
                              color: progressColor,
                            ),
                          ),

                          const SizedBox(width: 14),

                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [

                                Text(
                                  getCategoryName(b['category_id']),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                Text(
                                  "Đã tiêu ${spent.toStringAsFixed(0)} / ${amount.toStringAsFixed(0)}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                  ),
                                )
                              ],
                            ),
                          ),

                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.end,
                            children: [

                              Text(
                                "Còn ${remain.toStringAsFixed(0)}",
                                style: TextStyle(
                                  color: progressColor,
                                  fontWeight:
                                  FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),

                              Text(
                                status,
                                style: const TextStyle(
                                  color: Colors.grey,
                                ),
                              )
                            ],
                          )
                        ],
                      ),

                      const SizedBox(height: 15),

                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(10),
                        child: LinearProgressIndicator(
                          value: percent,
                          minHeight: 8,
                          backgroundColor:
                          Colors.grey.shade200,
                          valueColor:
                          AlwaysStoppedAnimation(
                              progressColor),
                        ),
                      )
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }

  void showAddBudgetDialog() {
    int? selectedCategoryId;
    TextEditingController amountController =
    TextEditingController();
    showDialog(
      context: context,
      builder: (context) {

        return StatefulBuilder(

          builder: (context, setStateDialog) {

            return AlertDialog(

              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(20),
              ),

              title: const Text(
                "Thêm ngân sách",
              ),

              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// CATEGORY
                  DropdownButtonFormField<int>(
                    value: selectedCategoryId,

                    decoration: InputDecoration(
                      labelText: "Danh mục",

                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),

                    items: categories.map((c) {
                      return DropdownMenuItem<int>(
                        value: c['id'],
                        child: Text(c['name']),
                      );

                    }).toList(),

                    onChanged: (value) {
                      setStateDialog(() {
                        selectedCategoryId = value;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  /// AMOUNT
                  TextField(
                    controller: amountController,
                    keyboardType:
                    TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Số tiền",
                      border: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),

              actions: [

                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Huỷ"),
                ),

                ElevatedButton(

                  onPressed: () async {

                    if(selectedCategoryId == null ||
                        amountController.text.isEmpty){
                      return;
                    }

                    bool result =
                    await ApiHelpers.addBudget(
                      userId: widget.userId,
                      categoryId:
                      selectedCategoryId!,
                      walletId: 1,
                      amount: double.parse(
                        amountController.text,
                      ),
                    );

                    if(result){
                      Navigator.pop(context);
                      loadBudgets();
                    }
                  },
                  child: const Text("Lưu"),
                )
              ],
            );
          },
        );
      },
    );
  }
}