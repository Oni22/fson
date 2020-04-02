# fson

Fson is a new notation developed for the Flutter Framework which helps you to create resources easily seperated from your code as known from iOS and Android. 

**Before you start:**
Check out the fson syntax highlighting plugin for VS Code. **For parsing fson this plugin is required.**
  
### 1. How to fson 

#### The basics

Before we start to create our first fson file we have to learn how to build a fson node. Fson node are written as follow:

```
my_id {
	key: "value"
}
```
A Fson node starts with an id which only allows **underscores** as special charachters. After that the body starts with curly brackets. Inside the body we have our keys with their values. **Values are always declared as strings**. 

To cascade multiple fson nodes we can seperate them with a comma. The last node hasn't a comma.
```
my_id {
	key: "value"
},
my_second_id {
	key: "value"
}
```
#### Arrays

You can also add arrays to a fson key. Arrays are declared as follows:

```
my_id {
	key: ["one","two","the"]
}
```

**Values inside the array are always declared as strings**. 


#### Referencing
With fson you can reference to other nodes with the following pattern:
```
my_id {
	key: "#(namspace.id.key)"
},
```
It could look like this:

**File1.fson:**
```
my_id {
	en: "#(strings.my_second_id.en)"
},
```
**File2.fson:**
```
my_second_id {
	en: "This is also added to my_id"
}
```

For referencing inside the same fson file you can use the same pattern.

## Getting Started with the plugin

### 1. Create namespaces
First of all we have to setup our namespaces (folders) where we will put our fson resource files. 
Currently this plugin supports two namespaces:
- colors

- strings

Create a **colors** and **strings** folder under your **lib/** directory.
Every namespace (folder) follows a specific fson schema. The next section will show you
how to create and build string and color resources with the correct schema.
  

### 2. String resources

#### Schema

Go to your **strings** namespace (folder) under **lib/** which you created before in step 1.
Here you create your first file e.g myStrings.fson. Then create your first fson node like:
```
myString {
	en: "Hi my name ist fson"
	de: "Hallo ich bin fson"
}

```
**The schema of the string namespace follows the ISO-3691-1 language codes  (e.g en or de).**
In the above example we use the keys "en" and "de" for english and german version.

#### Add Plurals
In this exmaple you can see the usage of plurals. To create plurals you can create an array with string values where the first item has the quantity 0 and so on.
```
mySecondString {
	en: ["plural one","plural two"],
	de: ["plural eins", "plural zwei"]
}
```
#### Placeholder
The string namespace also supports placeholders which you can assign at runtime in your code.
Single text and plurals support these placeholders. To assign placeholders you start with the %1p symbol.
If you have more than one placeholder in your text you can easily increase the number with %2p, %3p, %4p etc.
```
myThirdString {
	en: "The price of %1p is $ %2p ",
	de: ["item price %1p", "items price %1p"]
}
```

  

#### Generate string resources
Before you can use the string resources inside your code you have to generate the resources from the fson files. For that

type the following into your console:
```
flutter pub run fson:strgen
```

  

After the generation you can use your strings as follow:
```dart
//Get single text
var text = RStrings.myString.text();

//Get single text and replace placeholders
//returns "price of Apple is $ 1"
var text = RStrings.myThirdString.text(params: ["Apple",1]); 

//returns the plural with the quantity 0 in this case "plural one"
var text = RStrings.mySecondString.plural(0); 

//returns the plural with the quantity 1 in this case "items price 22"
var text = RStrings.myThirdString.plural(1,params: [22]); 
```
**You can create multiple fson files inside the strings folder. Fson combines all fson files inside a namespace (folder) and creates a single dart file.**

#### Adding localization to your app (REQUIRED)
**This step is required otherwise you will get errors!**
To activate the localization feature you have to do the following:
```dart
void  main() {runApp(MyApp());}

class  MyApp  extends  StatelessWidget {
	// This widget is the root of your application.
	@override
	Widget  build(BuildContext context) {
		return  MaterialApp(
			title: 'Flutter Demo',
			supportedLocales: [
				//add your language codes
				Locale("en","EN"), // we support this in our fson
				Locale("de","DE") // we support this in our fson
				//add more if needed and also add to your fsons
			],
			localizationsDelegates: [
				GlobalWidgetsLocalizations.delegate,
				GlobalMaterialLocalizations.delegate
			],
			localeResolutionCallback: (locale, supportedLocales) {
	
				for(var supported in supportedLocales) {
					if(supported.countryCode == locale.countryCode
					&& supported.languageCode == locale.languageCode) {
						// assign language code if it is supported
						RConfig.currentLanguageCode = supported.languageCode;
						return supported;
					}
				}
			// assign your back up language code if couldn't find supported language
			RConfig.backUpLanguageCode = "en";
			return locale;
			},
		);
	}
}
```
With the **RConfig** class you can configurate your resources. Be always sure that you have a **back up language**. **The standard back up language is english**.
  

### 2. Color resources

#### Schema

Go to your colors folder under lib/ which you created before in step 1.
Here you create your first file e.g myColors.fson. Then create your first fson node like:
```
myColor {
	day: "#00000"
}
```
The **day** key is a **required** key and it's have to be in **hex format**.

```
myColor {
	day: "#FFFFFF",
	night: "#000000"
}
```
**Optionally** you can add the **night** key which will selected if the dark mode is active.
To **activate** the dark mode feature you have to assign the **RConfig.isDarkMode** to true. 

#### Generate color resources
Before you can use the color resources inside your code you have to generate the resources from the fson files. For that type the following into your console:
```
flutter pub run fson:colorgen
```
After the generation you can use your colors as follow:
```dart
//Returns day or night color depending on which mode is active
Color(RColors.myColor.color)

//Returns day color
Color(RColors.myColor.day)

//Returns night color
Color(RColors.myColor.night)
```
