import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() =>
      _HistoryPageState();
}

class _HistoryPageState
    extends State<HistoryPage> {

  final supabase = Supabase.instance.client;

  List<Map<String, dynamic>> histories = [];

  bool isLoading = true;

  String selectedFilter = "all";

  @override
  void initState() {
    super.initState();
    fetchHistory();
  }

  /// GET HISTORY
  Future<void> fetchHistory() async {

    try {

      final user =
          supabase.auth.currentUser;

      final data = await supabase
          .from('history')
          .select()
          .eq('user_id', user!.id)
          .order(
            'created_at',
            ascending: false,
          );

      setState(() {
        histories =
            List<Map<String, dynamic>>
                .from(data);

        isLoading = false;
      });

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          content:
              Text("Error: $e"),
        ),
      );
    }
  }

  /// FILTER
  List<Map<String, dynamic>>
      get filteredHistory {

    if (selectedFilter == "all") {
      return histories;
    }

    return histories.where((item) {
      return item['type'] ==
          selectedFilter;
    }).toList();
  }

  /// FILTER BUTTON
  Widget filterButton(
    String label,
    String value,
  ) {

    final isActive =
        selectedFilter == value;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedFilter = value;
        });
      },

      child: Container(
        margin:
            const EdgeInsets.only(
          right: 8,
        ),

        padding:
            const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 7,
        ),

        decoration: BoxDecoration(
          color: isActive
              ? Colors.deepPurple
              : Theme.of(context).cardColor,

          borderRadius: BorderRadius.circular(12),

          border: Border.all(
            color: Colors.deepPurple,
          ),
        ),

        child: Text(
          label,
          style: TextStyle(
            fontSize: 13,
            color: isActive
                ? Colors.white
                : Colors.deepPurple,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    final data = filteredHistory;

    return Scaffold(
      backgroundColor:
          Theme.of(context).scaffoldBackgroundColor,

      body: SafeArea(
        child: isLoading

            ? const Center(
                child:
                    CircularProgressIndicator(),
              )

            : Column(
                children: [

                  const SizedBox(
                    height: 12,
                  ),

                  /// FILTER BUTTONS
                 Center(
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      alignment: WrapAlignment.center,
                      children: [
                        filterButton("Semua", "all"),
                        filterButton("Catatan", "note"),
                        filterButton("Selesai", "done_task"),
                        filterButton("Dihapus", "deleted_task"),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  /// HISTORY LIST
                  Expanded(
                    child: data.isEmpty

                        ? const Center(
                            child: Text(
                              "Belum ada riwayat",
                            ),
                          )

                        : ListView.builder(
                            padding:
                                const EdgeInsets.all(
                              16,
                            ),

                            itemCount:
                                data.length,

                            itemBuilder:
                                (
                                  context,
                                  index,
                                ) {

                              final item =
                                  data[index];

                              return Container(
                                margin:
                                    const EdgeInsets.only(
                                  bottom: 14,
                                ),

                                padding:
                                    const EdgeInsets.all(
                                  16,
                                ),

                                decoration:
                                    BoxDecoration(
                                  color:
                                    Theme.of(context).cardColor,

                                  borderRadius:
                                      BorderRadius
                                          .circular(
                                    18,
                                  ),

                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors
                                          .black
                                          .withOpacity(
                                        0.04,
                                      ),

                                      blurRadius: 10,

                                      offset:
                                          const Offset(
                                        0,
                                        4,
                                      ),
                                    ),
                                  ],
                                ),

                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,

                                  children: [

                                    Row(
                                      children: [

                                        Icon(

                                          item['type'] ==
                                                  'note'

                                              ? Icons.notes

                                              : item['type'] ==
                                                      'task'

                                                  ? Icons
                                                      .event_note

                                                  : item['type'] ==
                                                          'done_task'

                                                      ? Icons
                                                          .check_circle

                                                      : Icons
                                                          .delete,

                                          size: 22,

                                          color:

                                              item['type'] ==
                                                      'note'

                                                  ? const Color(0xFFAD33FF)

                                                  : item['type'] ==
                                                          'task'

                                                      ? Colors
                                                          .deepPurple

                                                      : item['type'] ==
                                                              'done_task'

                                                          ? const Color(0xFFAD33FF)

                                                          : Colors
                                                              .red,
                                        ),

                                        const SizedBox(
                                          width: 10,
                                        ),

                                        Expanded(
                                          child: Text(
                                            item['title'] ??
                                                '',

                                            style:
                                                const TextStyle(
                                              fontSize:
                                                  16,

                                              fontWeight:
                                                  FontWeight
                                                      .bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),

                                    const SizedBox(
                                      height: 10,
                                    ),

                                    Text(
                                      item['description'] ??
                                          '',

                                      style:
                                          TextStyle(
                                        color: Colors
                                            .grey
                                            .shade700,

                                        height: 1.5,
                                      ),
                                    ),

                                    const SizedBox(
                                      height: 12,
                                    ),

                                    Text(
                                      item['created_at']
                                          .toString()
                                          .substring(
                                            0,
                                            16,
                                          ),

                                      style:
                                          TextStyle(
                                        color: Colors
                                            .grey
                                            .shade500,

                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}