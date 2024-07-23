import 'package:dars2/utils/constants/products_graphql_queries.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? _image;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (ctx) => Wrap(
        children: [
          ListTile(
            leading: const Icon(Icons.camera),
            title: const Text('Camera'),
            onTap: () {
              Navigator.of(ctx).pop();
              _pickImage(ImageSource.camera);
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library),
            title: const Text('Gallery'),
            onTap: () {
              Navigator.of(ctx).pop();
              _pickImage(ImageSource.gallery);
            },
          ),
        ],
      ),
    );
  }

  void _showEditDialog(BuildContext context, Map product, Function refetch) {
    final TextEditingController titleController =
        TextEditingController(text: product['title']);
    final TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    final TextEditingController priceController =
        TextEditingController(text: product['price'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String title = titleController.text;
                String description = descriptionController.text;
                double price = double.tryParse(priceController.text) ?? 0.0;

                GraphQLProvider.of(context).value.mutate(
                      MutationOptions(
                        document: gql(editProduct),
                        variables: {
                          "id": product['id'],
                          "title": title,
                          "description": description,
                          "price": price,
                        },
                        onCompleted: (data) {
                          refetch(); // Refetch the product list after editing
                          Navigator.of(context).pop();
                          print(data);
                        },
                        onError: (error) {
                          print(error!.linkException);
                        },
                      ),
                    );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAdddialog(BuildContext context, Map product, Function refetch) {
    final TextEditingController titleController =
        TextEditingController(text: product['title']);
    final TextEditingController descriptionController =
        TextEditingController(text: product['description']);
    final TextEditingController priceController =
        TextEditingController(text: product['price'].toString());
    final TextEditingController imageController =
        TextEditingController(text: product['price'].toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String title = titleController.text;
                String description = descriptionController.text;
                double price = double.tryParse(priceController.text) ?? 0.0;

                GraphQLProvider.of(context).value.mutate(
                      MutationOptions(
                        document: gql(editProduct),
                        variables: {
                          "id": product['id'],
                          "title": title,
                          "description": description,
                          "price": price,
                        },
                        onCompleted: (data) {
                          refetch(); // Refetch the product list after editing
                          Navigator.of(context).pop();
                          print(data);
                        },
                        onError: (error) {
                          print(error!.linkException);
                        },
                      ),
                    );
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showAddDialog(BuildContext context, Function refetch) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController priceController = TextEditingController();
    final TextEditingController categoryIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Product'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Title'),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                ),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: categoryIdController,
                  decoration: const InputDecoration(labelText: 'Category ID'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 10),
                _image != null
                    ? Image.file(_image!, height: 100, width: 100)
                    : const Text('No image selected'),
                ElevatedButton(
                  onPressed: () => _showImageSourceActionSheet(context),
                  child: const Text('Pick Image'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String title = titleController.text;
                String description = descriptionController.text;
                double price = double.tryParse(priceController.text) ?? 0.0;
                double categoryId =
                    double.tryParse(categoryIdController.text) ?? 0.0;
                List<String> images = _image != null ? [_image!.path] : [];

                GraphQLProvider.of(context).value.mutate(
                      MutationOptions(
                        document: gql(addProduct),
                        variables: {
                          "title": title,
                          "description": description,
                          "price": price,
                          "categoryId": categoryId,
                          "images": images,
                        },
                        onCompleted: (data) {
                          refetch(); // Refetch the product list after adding
                          Navigator.of(context).pop();
                          print(data);
                        },
                        onError: (error) {
                          print(error?.graphqlErrors);
                        },
                      ),
                    );
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Products"),
        actions: [
          IconButton(
            onPressed: () {
              _showAddDialog(context, () => setState(() {}));
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Query(
        options: QueryOptions(
          document: gql(getProducts),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (result.hasException) {
            return Center(
              child: Text(result.exception.toString()),
            );
          }

          List products = result.data!['products'];

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (ctx, index) {
              return ListTile(
                leading: GestureDetector(
                  onTap: () => _showImageSourceActionSheet(context),
                  child: CircleAvatar(
                    radius: 30,
                    backgroundImage: _image != null
                        ? FileImage(_image!)
                        : NetworkImage(
                            products[index]['images'][0].split('"')[1],
                          ) as ImageProvider,
                  ),
                ),
                title: Text(
                  products[index]['title'],
                ),
                subtitle: Text(products[index]['description']),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () {
                        _showEditDialog(context, products[index], refetch!);
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        GraphQLProvider.of(context).value.mutate(
                              MutationOptions(
                                document: gql(deleteProduct),
                                variables: {'id': products[index]['id']},
                                onCompleted: (data) {
                                  refetch!(); // Refetch the product list after deletion
                                  print(data);
                                },
                                onError: (error) {
                                  print(error!.linkException);
                                },
                              ),
                            );
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
