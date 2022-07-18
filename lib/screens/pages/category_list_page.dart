import 'package:education/providers/videos_data.dart';
import 'package:provider/provider.dart';
import 'package:education/screens/categorized_videos_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:education/widgets/category_item_widget.dart';

class CategoryListPage extends StatelessWidget {
  const CategoryListPage({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Consumer<VideosData>(
            builder: (context, videosData, child){
              return GridView.builder(
                scrollDirection: Axis.vertical,
                physics: const BouncingScrollPhysics(),
                itemCount: videosData.categoriesCount,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 8, crossAxisSpacing: 8, childAspectRatio: 3 / 2,),
                itemBuilder: (context, index){
                  return InkWell(
                    overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
                    highlightColor: Colors.transparent,
                    onTap: (){
                      Navigator.of(context).pushNamed(CategorizedVideos.routeName, arguments: videosData.categories[index].id);
                    },
                    child: CategoryItem(title: videosData.categories[index].title, image: videosData.categories[index].image,),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
