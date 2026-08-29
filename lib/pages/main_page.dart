import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:to_do_list/components/note_item.dart';
import 'package:to_do_list/service/model/note_model.dart';
import '../main.dart';
import '../service/api_servise.dart'; // MyApp ga ulanish uchun

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String selected = "All";
  List<NoteModel> notes = [];
  bool done = false; // Holatni saqlash uchun state'ga o'tkazdik
  late TextEditingController noteController;
  late TextEditingController descController;


  void readNote()async{
    List<NoteModel> newnotes = await ApiService.fetchNotes();
    setState(() {
      notes = newnotes;
    });
    print("hello3---------------readNote");

  }

  Future<void> addNote()async{
    NoteModel note = NoteModel(title: noteController.text, description: descController.text, deadline: DateTime.now().toIso8601String().split('T')[0]);
   await ApiService.addNote(note);
    Navigator.pop(context);
    print("hello2---------------addNote");
  }



  @override
  void initState() {
    // TODO: implement initState
    noteController = TextEditingController();
    descController = TextEditingController();
    super.initState();
    readNote();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    noteController.dispose();
    descController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isLight = Theme.of(context).brightness == Brightness.light;
    
    final filteredNotes = notes.where((note) {
      if (selected == "ALL") return true;
      if (selected == "COMPLETE") return note.status == "Completed";
      if (selected == "INCOMPLETE") return note.status=="Not Started";
      return true;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorScheme.surface,
        title: Text(
          "TODO LIST",
          style: GoogleFonts.kanit(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_outlined, color: colorScheme.onPrimary),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: colorScheme.primary,
              child: Padding(padding: EdgeInsets.all(10), child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("New Note",  style: GoogleFonts.kanit(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onPrimary,
                  ),),
                  TextField(
                    style: TextStyle(color: colorScheme.onPrimary),
                    controller:  noteController,
                    decoration: InputDecoration(
                      hintText: "Add a note..,",
                      hintStyle: TextStyle(
                        color: colorScheme.onPrimary.withOpacity(
                          0.6,
                        ),
                        fontSize: 14,
                      ),
                      contentPadding:  EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: colorScheme.surface,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: colorScheme.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextField(
                    style: TextStyle(color: colorScheme.onPrimary),
                    controller: descController,
                    decoration: InputDecoration(
                      hintText: "Add a describtion..,",
                      hintStyle: TextStyle(
                        color: colorScheme.onPrimary.withOpacity(
                          0.6,
                        ),
                        fontSize: 14,
                      ),
                      contentPadding:  EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: colorScheme.surface,
                          width: 1.5,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide(
                          color: colorScheme.surface,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40), // TextField va tugmalar orasidagi masofa

                  // TUGMALAR QISMI (Joy tashlab o'ng va chapga surish)
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // << Asosiy mantiq shu yerda
                      children: [
                        // 1. CANCEL tugmasi (Border bilan)
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side:  BorderSide(color: colorScheme.onPrimary, width: 1.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding:  EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          ),
                          child:  Text(
                            'CANCEL',
                            style: TextStyle(
                              color: colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                        // 2. APPLY tugmasi (To'liq bo'yalgan)
                        ElevatedButton(
                          onPressed: () async{
                           await addNote();
                            readNote();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor:  colorScheme.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding:  EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                          ),
                          child:  Text(
                            'APPLY',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                  )]
              )),
            ),
          );
        },
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            // Asosiy elementlar vertikal joylashadi
            children: [
              // 1. Qidiruv va filtrlar qatori
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 42,
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Search note...',
                          hintStyle: TextStyle(
                            color: colorScheme.primary.withOpacity(
                              0.6,
                            ),
                            fontSize: 14,
                          ),
                          suffixIcon: Icon(
                            Icons.search,
                            color: colorScheme.primary,
                            size: 20,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(
                              color: colorScheme.primary,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 38,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selected,
                        dropdownColor: colorScheme.primary,
                        icon: Icon(
                          Icons.keyboard_arrow_down_outlined,
                          color: colorScheme.onPrimary,
                          size: 18,
                        ),
                        style: TextStyle(color: colorScheme.onPrimary),
                        items: ["All", "COMPLETE", "INCOMPLETE"].map((
                          String value,
                        ) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            selected = newValue!;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    height: 38,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: IconButton(
                      onPressed: () {
                        final newMode = isLight
                            ? ThemeMode.dark
                            : ThemeMode.light;
                        MyApp.of(context).changeTheme(newMode);
                      },
                      icon: Icon(
                        isLight
                            ? Icons.nightlight_round_outlined
                            : Icons.wb_sunny_outlined,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 20,
              ), // Qidiruv qatori va ro'yxat orasida masofa
              // 2. Ro'yxat qismi - Column ichida Expanded bo'lishi shart!
              Expanded(
                child: ListView.separated(
                  itemCount: filteredNotes.length,
                  separatorBuilder: (context, index) =>
                      Divider(color: colorScheme.outlineVariant),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
                      child: NoteItemWidget(
                          key: ValueKey(filteredNotes[index].id),
                          note: filteredNotes[index]),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


