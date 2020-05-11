import 'package:delicat/models/category.dart';
import 'package:delicat/providers/categories.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NewCatScreen extends StatefulWidget {
  const NewCatScreen({Key key}) : super(key: key);

  static const routeName = '/new-cat';

  @override
  _NewCatScreenState createState() => _NewCatScreenState();
}

class _NewCatScreenState extends State<NewCatScreen> {
  var _initValues = {
    'name': '',
    'colorCode': '',
  };

  var _editedCategory = Category(name: "", colorCode: "");

  final _colorFocusNode = FocusNode();

  final _form = GlobalKey<FormState>();
  var _isInit = true;
  var _isLoading = false;

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
    });
    if (_editedCategory.id != null) {
      await Provider.of<Categories>(context, listen: false)
          .updateCategory(_editedCategory.id, _editedCategory);
    } else {
      try {
        await Provider.of<Categories>(context, listen: false)
            .createCategory(_editedCategory);

        Navigator.of(context).pop();
      } catch (error) {
        print("edited category: $_editedCategory");
        await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong.'),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
              )
            ],
          ),
        );
      }
    }
    setState(() {
      _isLoading = false;
    });
    // Navigator.of(context).pop();
  }

  @override
  void dispose() {
    _colorFocusNode.dispose();
    super.dispose();
  }

  @override
  //This function will check for existing values if we're editing a Category
  void didChangeDependencies() async {
    if (_isInit) {
      //Getting product id from the link, only when editing
      final catId = ModalRoute.of(context).settings.arguments as String;
      if (catId != null) {
        _editedCategory = await Provider.of<Categories>(context, listen: false)
            .findById(catId); // not available
        _initValues = {
          'name': _editedCategory.name,
          'colorCode': _editedCategory.colorCode,
        };
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("New Cat Screen"),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Form(
                key: _form,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _initValues['name'],
                      decoration: InputDecoration(labelText: 'Name'),
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_colorFocusNode);
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please provide a value.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCategory = Category(
                          name: value,
                          colorCode: _editedCategory.colorCode,
                        );
                      },
                    ),
                    TextFormField(
                      initialValue: _initValues['colorCode'],
                      decoration: InputDecoration(labelText: 'Color'),
                      focusNode: _colorFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        //for now this is the last input field, so we save form
                        _saveForm();
                        //move this to the last input field as needed
                        //preferrably with a submit button in the form
                        //FocusScope.of(context).requestFocus(_); got to next field, if we'll have eventually
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Select a value from color picker:';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedCategory = Category(
                          name: _editedCategory.name,
                          colorCode: value,
                        );
                      },
                    ),
                    FlatButton(onPressed: _saveForm, child: Text("Submit form"))
                  ],
                ),
              ),
            ),
    );
  }
}
