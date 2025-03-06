import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:journey/core/models/zettelfolder.dart';
import 'package:journey/core/models/zettelnote.dart';
import 'package:journey/widgets/apptheme.dart';
class GraphZoomDrawer extends StatelessWidget {
  final List<ZettelNote> notes;
  final List<ZettelFolder> folders;
  final bool isLoadingFolders;
  final bool isSearching;
  final List<ZettelNote> filteredNotes;
  final String? currentFolderId;
  final TextEditingController searchController;

  // Callbacks for interactions
  final VoidCallback onAllNotesTap;
  final void Function(String folderId) onFolderTap;
  final VoidCallback onCreateFolder;
  final VoidCallback onClearSearch;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onSettingsTap;
  final VoidCallback onHelpTap;
  final VoidCallback onInfoTap;

  // Main screen widget (your graph view or other main content)
  final Widget mainScreen;

  // Controller for the ZoomDrawer
  final ZoomDrawerController zoomDrawerController;

  const GraphZoomDrawer({
    Key? key,
    required this.notes,
    required this.folders,
    required this.isLoadingFolders,
    required this.isSearching,
    required this.filteredNotes,
    required this.currentFolderId,
    required this.searchController,
    required this.onAllNotesTap,
    required this.onFolderTap,
    required this.onCreateFolder,
    required this.onClearSearch,
    required this.onSearchChanged,
    required this.onSettingsTap,
    required this.onHelpTap,
    required this.onInfoTap,
    required this.mainScreen,
    required this.zoomDrawerController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: zoomDrawerController,
      borderRadius: 24,
      showShadow: true,
      angle: -12.0,
      drawerShadowsBackgroundColor: AppTheme.deepSpace,
      slideWidth: MediaQuery.of(context).size.width * 0.85,
      menuBackgroundColor: Colors.transparent,
      mainScreenTapClose: true,
      style: DrawerStyle.defaultStyle,
      menuScreen: _buildDrawerContent(context),
      mainScreen: mainScreen,
    );
  }

  Widget _buildDrawerContent(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppTheme.deepSpace.withOpacity(0.95),
            AppTheme.nebulaPurple.withOpacity(0.8),
          ],
        ),
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDrawerHeader(),
            const SizedBox(height: 16),
            _buildAllNotesTile(),
            if (isSearching)
              ..._buildSearchResults()
            else
              ..._buildFoldersSection(),
            _buildDrawerFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppTheme.nebulaPurple.withOpacity(0.7),
                AppTheme.cosmicBlue.withOpacity(0.5),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [AppTheme.nebulaPurple, AppTheme.cosmicBlue],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppTheme.nebulaPurple.withOpacity(0.5),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.auto_graph,
                      color: AppTheme.starWhite,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Zettelkasten',
                    style: TextStyle(
                      color: AppTheme.starWhite,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          color: AppTheme.nebulaPurple.withOpacity(0.8),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Search Bar
              Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(
                    color: AppTheme.starWhite.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: TextField(
                  controller: searchController,
                  style: const TextStyle(color: AppTheme.starWhite),
                  decoration: InputDecoration(
                    hintText: 'Search notes...',
                    hintStyle: TextStyle(
                      color: AppTheme.starWhite.withOpacity(0.5),
                    ),
                    border: InputBorder.none,
                    prefixIcon:
                        const Icon(Icons.search, color: AppTheme.starWhite),
                    suffixIcon: searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear,
                              color: AppTheme.starWhite,
                            ),
                            onPressed: onClearSearch,
                          )
                        : null,
                  ),
                  onChanged: onSearchChanged,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAllNotesTile() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onAllNotesTap,
          borderRadius: BorderRadius.circular(15),
          child: Ink(
            decoration: BoxDecoration(
              color: (currentFolderId == null && !isSearching)
                  ? AppTheme.nebulaPurple.withOpacity(0.3)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: AppTheme.starWhite.withOpacity(0.2),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppTheme.deepSpace.withOpacity(0.5),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppTheme.starWhite.withOpacity(0.3),
                        width: 1,
                      ),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.notes,
                        color: AppTheme.starWhite,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'All Notes',
                        style: TextStyle(
                          color: AppTheme.starWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${notes.length} notes',
                        style: TextStyle(
                          color: AppTheme.starWhite.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildSearchResults() {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Row(
          children: [
            const Icon(Icons.search, color: AppTheme.starWhite, size: 18),
            const SizedBox(width: 8),
            Text(
              'Search Results (${filteredNotes.length})',
              style: const TextStyle(
                color: AppTheme.starWhite,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      Expanded(
        flex: 2,
        child: filteredNotes.isEmpty
            ? Center(
                child: Text(
                  'No matching notes',
                  style: TextStyle(
                    color: AppTheme.starWhite.withOpacity(0.6),
                    fontStyle: FontStyle.italic,
                  ),
                ),
              )
            : ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: filteredNotes.length,
                itemBuilder: (context, index) {
                  final note = filteredNotes[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          // Add a callback if a note is selected from search.
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Ink(
                          decoration: BoxDecoration(
                            color: AppTheme.deepSpace.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: AppTheme.starWhite.withOpacity(0.1),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: AppTheme.nebulaPurple.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.note_alt_outlined,
                                      color: AppTheme.starWhite,
                                      size: 20,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        note.title,
                                        style: const TextStyle(
                                          color: AppTheme.starWhite,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        note.content,
                                        style: TextStyle(
                                          color: AppTheme.starWhite.withOpacity(0.7),
                                          fontSize: 12,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
    ];
  }

  List<Widget> _buildFoldersSection() {
    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Folders',
              style: TextStyle(
                color: AppTheme.starWhite,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.create_new_folder_outlined,
                color: AppTheme.starWhite,
                size: 20,
              ),
              onPressed: onCreateFolder,
              tooltip: 'Create new folder',
            ),
          ],
        ),
      ),
      Expanded(
        child: isLoadingFolders
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.starWhite),
              )
            : folders.isEmpty
                ? Center(
                    child: Text(
                      'No folders yet',
                      style: TextStyle(
                        color: AppTheme.starWhite.withOpacity(0.6),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  )
                : AnimationLimiter(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: folders.length,
                      itemBuilder: (context, index) {
                        final folder = folders[index];
                        return AnimationConfiguration.staggeredList(
                          position: index,
                          duration: const Duration(milliseconds: 375),
                          child: SlideAnimation(
                            verticalOffset: 50.0,
                            child: FadeInAnimation(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => onFolderTap(folder.id),
                                    borderRadius: BorderRadius.circular(12),
                                    child: Ink(
                                      decoration: BoxDecoration(
                                        color: (currentFolderId == folder.id)
                                            ? AppTheme.nebulaPurple.withOpacity(0.3)
                                            : AppTheme.deepSpace.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: (currentFolderId == folder.id)
                                              ? AppTheme.nebulaPurple.withOpacity(0.6)
                                              : AppTheme.starWhite.withOpacity(0.1),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Row(
                                          children: [
                                            Stack(
                                              alignment: Alignment.center,
                                              children: [
                                                Container(
                                                  width: 40,
                                                  height: 40,
                                                  decoration: const BoxDecoration(
                                                    color: AppTheme.nebulaPurple,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.folder,
                                                    color: AppTheme.starWhite,
                                                    size: 20,
                                                  ),
                                                ),
                                                if (folder.noteIds.isNotEmpty)
                                                  Positioned(
                                                    right: 0,
                                                    bottom: 0,
                                                    child: Container(
                                                      width: 20,
                                                      height: 20,
                                                      decoration: BoxDecoration(
                                                        color: AppTheme.cosmicBlue,
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color: AppTheme.deepSpace,
                                                          width: 1.5,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          folder.noteIds.length.toString(),
                                                          style: const TextStyle(
                                                            color: AppTheme.starWhite,
                                                            fontSize: 10,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                              ],
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              folder.name,
                                              style: const TextStyle(
                                                color: AppTheme.starWhite,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
      ),
    ];
  }

  Widget _buildDrawerFooter() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          const Divider(
            color: AppTheme.starWhite,
            height: 1,
            thickness: 0.5,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.settings_outlined, color: AppTheme.starWhite),
                onPressed: onSettingsTap,
              ),
              IconButton(
                icon: const Icon(Icons.help_outline, color: AppTheme.starWhite),
                onPressed: onHelpTap,
              ),
              IconButton(
                icon: const Icon(Icons.info_outline, color: AppTheme.starWhite),
                onPressed: onInfoTap,
              ),
            ],
          ),
        ],
      ),
    );
  }
}