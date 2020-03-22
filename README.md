# string_res

FResources creates resources for Flutter projects with the help of the fson notation.
With the easy syntax of fson you seperate your resources from your code.

**RECOMMENDED PLUGIN FOR VS CODE: fson. This plugin provides syntax highlighting for the fson notation**

## Getting Started

### 1. Create folders

Before you start you have to create some folders. Create the following folders under
your lib/ folder:

- colors
- strings

Inside these folders you will create your fson resources later.

### 2. Create your first resource

Every folder takes fson's with a specific schema. This section will show 
you how to create colors and strings with the specific schema.

#### Creating string resources

Go to your strings folder under lib/ which you created before in step 1. 
Here you create your first file e.g myStrings.fson. Then create your first 
fson node like:

```
myString {
    en: "Hi my name ist fson"
    de: "Hallo ich bin fson"
}
```

The strings namespace supports all ISO-3691-1 language codes (e.g en or de). 
In the above example we use the keys "en" and "de" for english and german version.

Let's add another string:

```
myString {
    en: "Hi my name ist fson"
    de: "Hallo ich bin fson"
},
mySecondString {
    en: ["plural one","plural two"],
    de: ["plural ein", "plural zwei"]
}
```

In this exmaple you can see the usage of plurals. To create plurals you can create an array with string values where the
first item has the quantity 0 and so on.

Let's add another final string:

```
myString {
    en: "Hi my name ist fson"
    de: "Hallo ich bin fson"
},
mySecondString {
    en: ["plural one","plural two"],
    de: ["plural ein", "plural zwei"]
},
myThirdString {
    en: "The price of %1p is $ %2p ",
    de: ["item price %1p", "items price %1p"]
}
```
The string namespace also supports placeholders which you can assign at runtime in your code.
Single text and plurals support these placeholders. To assign placeholders you start with the %1p symbol. 
If you have more than one placeholder in your text you can easily increase the number with %2p, %3p, %4p etc.

#### Generate string resources

Before you can use the string resources inside your code you have to generate the resources from the fson files. For that
type the following into your console:

```
flutter pub run string_res:strgen
```

After the generation you can use your strings as follow:


```dart
//Get single text
RStrings.myString.text()

//Get single text and replace placeholders
RStrings.myThirdString.text(params: ["Apple",1]) //returns "price of Apple is $ 1"

RStrings.mySecondString.plural(0) //returns the plural with the quantity 0 in this case "plural one"

RStrings.myThirdString.plural(1,params: [22]) //returns the plural with the quantity 1 in this case "items price 22"

```

**You can create multiple fson files inside the strings folder. FResource combines all fson files inside a folder and creates a single dart file with the data.**

#### Adding localization to your app (REQUIRED)

As you see you can define multiple language codes inside a fson string node. To use that feature you have 
to assign the current language to the RConfig.currentLanguageCode value. 

```dart
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              RService.currentLanguageCode = supported.languageCode;
              return supported;
            }
          }

        // assing your backUp language code if couldn't find supported language
        RService.backUpLanguageCode = "en";
        return locale;

      },
    );
  }
}

```

#### Creating color resources

Go to your colors folder under lib/ which you created before in step 1. 
Here you create your first file e.g myColors.fson. Then create your first 
fson node like:

```
myColor {
    day: "#00000"
}
```

The "day" key is a required key and it's have to be in hex format.

```
myColor {
    day: "#000000",
    night: "#FFFFFF"
}
```

Optionally you can add the night key which will selected if the dark mode is active.

**To use the dark mode feature you have to assign the RConfig.isDarkMode value to true at a specifc point.** 

#### Generate color resources

Before you can use the color resources inside your code you have to generate the resources from the fson files. For that
type the following into your console:

```
flutter pub run string_res:colorgen
```

After the generation you can use your strings as follow:

```dart
//Returns day or night color depending on which mode is active
Color(RColors.myColor.color)

//Returns day color
Color(RColors.myColor.day)

//Returns night color
Color(RColors.myColor.night)

```

### Referencing resources

With the fson notation you can reference other resources to save redundant code.
You can create multiple fson files inside a namespace e.g in the strings folder.
Let's show it with a example:

Under the lib/strings folder we have myFirstFile.fson and mySecondFile.fson. 

Inside myFirstFile: 

```
...
myString {
    en: "#(strings.refString.en)"
},
...
```

Inside mySecondFile: 

```
...
refString {
    en: "from ref String"
},
...
```

With "#(strings.refString.en)" we reference the refString's "en" value. 
So the "en" value of string is now "from ref String". 
The syntax is as follow:

***#(namespace.id.key)**

You also can reference other namespaces like colors from the strings namespace.