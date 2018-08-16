module gencnv;

import std.stdio;
import std.regex;
import std.array;
import std.algorithm;
import std.typecons;

alias Table = Tuple!(string[], "columns", string[], "rows", bool[][], "data");

auto parseSource (string src) {
	auto rxLine = regex(`\r?\n`);
	auto rxField = regex(`\t`);
	auto lines = src.split(rxLine).array;
	string[] columns = lines[0].split(rxField).array[1..$];
	string[] rows;
	bool[][] data;
	foreach (line; lines[1..$]) {
		auto fields = line.split(rxField);
		rows ~= fields[0];
		data ~= fields[1..$].map!(x => x == "1").array;
	}
	return Table(columns, rows, data);
}

alias Entry = Tuple!(string,string,string);

auto createSyllables (Table table) {
	auto initials = table.rows;
	auto finals = table.columns;
	auto data = table.data;
	Entry[] syllables;
	for (int n = 0; n < initials.length; n++) {
		string i = initials[n];
		for (int m = 0; m < finals.length; m++) {
			if (data[n][m]) {
				string f = finals[m];
				switch (f) {
					case "ia":
						if (i == "") {							
							syllables ~= Entry (i ~ "ya", i, f);
						}
						else {
							syllables ~= Entry (i ~ f, i, f);
						}
						break;
					case "i":
						if (i == "") {							
							syllables ~= Entry (i ~ "yi", i, f);
						}
						else {
							syllables ~= Entry (i ~ f, i, f);
						}
						break;
					case "ie":
						if (i == "") {							
							syllables ~= Entry (i ~ "ye", i, f);
						}
						else {
							syllables ~= Entry (i ~ f, i, f);
						}
						break;
					case "iao":
						if (i == "") {							
							syllables ~= Entry (i ~ "yao", i, f);
						}
						else {
							syllables ~= Entry (i ~ f, i, f);
						}
						break;
					case "iou":
						if (i == "") {
							syllables ~= Entry (i ~ "you", i, f);
						}
						else {
							syllables ~= Entry (i ~ "iu", i, f);
						}
						break;
					case "ian":
						if (i == "") {							
							syllables ~= Entry (i ~ "yan", i, f);
						}
						else {
							syllables ~= Entry (i ~ f, i, f);
						}
						break;
					case "in":
						if (i == "") {
							syllables ~= Entry (i ~ "yin", i, f);
						}
						else {
							syllables ~= Entry (i ~ f, i, f);
						}
						break;
					case "ing":
						if (i == "") {							
							syllables ~= Entry (i ~ "ying", i, f);
						}
						else {
							syllables ~= Entry (i ~ f, i, f);
						}
						break;
					case "iang":
						if (i == "") {							
							syllables ~= Entry (i ~ "yang", i, f);
						}
						else {
							syllables ~= Entry (i ~ f, i, f);
						}
						break;
					case "iong":
						if (i == "") {
							syllables ~= Entry (i ~ "yong", i, f);
						}
						else {
							syllables ~= Entry (i ~ f, i, f);
						}
						break;
					case "u":
						if (i == "") {							
							syllables ~= Entry ("wu", i, f);
						}
						else {
							syllables ~= Entry (i ~ f, i, f);
						}
						break;
					case "ua":
						if (i == "") {							
							syllables ~= Entry ("wa", i, f);
						}
						else {
							syllables ~= Entry (i ~ f, i, f);
						}
						break;
					case "uo":
						if (i == "") {
							syllables ~= Entry ("wo", i, f);
						}
						else {
							syllables ~= Entry (i ~ f, i, f);
						}
						break;
					case "uai":
						if (i == "") {							
							syllables ~= Entry ("wai", i, f);
						}
						else {
							syllables ~= Entry (i ~ f, i, f);
						}
						break;
					case "uei":
						if (i == "") {						
							syllables ~= Entry ("wei", i, f);
						}
						else {							
							syllables ~= Entry (i ~ "ui", i, f);
						}
						break;
					case "uan":
						if (i == "") {
							syllables ~= Entry ("wan", i, f);
						}
						else {
							syllables ~= Entry (i ~ f, i, f);
						}
						break;
					case "uen":
						if (i == "") {							
							syllables ~= Entry ("wen", i, f);
						}
						else {							
							syllables ~= Entry (i ~ "un", i, f);
						}
						break;
					case "uang":
						if (i == "") {							
							syllables ~= Entry ("wang", i, f);
						}
						else {
							syllables ~= Entry (i ~ f, i, f);
						}
						break;
					case "ueng":
						if (i == "") {
							syllables ~= Entry ("weng", i, f);
						}
						else {
							syllables ~= Entry (i ~ f, i, f);
						}						
						break;
					case "ü":						
						switch (i) {
							case "":								
								syllables ~= Entry ("yu", i, f);
								break;
							case "j":
							case "q":
							case "x":
								syllables ~= Entry (i ~ "u", i, f);
								break;
							default:
								syllables ~= Entry (i ~ "v", i, f);
								break;
						}
						break;
					case "üe":						
						switch (i) {
							case "":								
								syllables ~= Entry ("yue", i, f);
								break;
							case "j":
							case "q":
							case "x":								
								syllables ~= Entry (i ~ "ue", i, f);
								break;
							default:
								syllables ~= Entry (i ~ "ve", i, f);
								break;
						}
						break;
					case "üan":						
						switch (i) {
							case "":								
								syllables ~= Entry ("yuan", i, f);
								break;
							case "j":
							case "q":
							case "x":						
								syllables ~= Entry (i ~ "uan", i, f);
								break;
							default:
								break;
						}
						break;
					case "ün":						
						switch (i) {
							case "":								
								syllables ~= Entry ("yun", i, f);
								break;
							case "j":
							case "q":
							case "x":								
								syllables ~= Entry (i ~ "um", i, f);
								break;
							default:
								break;
						}
						break;
					default:
						syllables ~= Entry (i ~ f, i, f);
						break;
				}
			}
		}
	}
	return syllables;
}

auto addTones (Entry[] entries) {
	Tuple!(string,string)[] syllables;
	foreach (e; entries) {
		string s = e[0];
		string i = e[1];
		string f = e[2];
		switch (f) {
			default:				
				break;
			case "a":
			case "ai":
			case "ao":
			case "an":
			case "ang":
			case "ia":
			case "iao":
			case "ian":
			case "iang":
			case "ua":
			case "uai":
			case "uan":
			case "uang":
			case "üan":
				syllables ~= tuple (s ~ "1", s.replace("a", "ā"));
				syllables ~= tuple (s ~ "2", s.replace("a", "á"));
				syllables ~= tuple (s ~ "3", s.replace("a", "ǎ"));
				syllables ~= tuple (s ~ "4", s.replace("a", "à"));
				syllables ~= tuple (s ~ "5", s);
				break;
			case "o":
			case "ou":					
			case "ong":			
			case "iong":
			case "uo":				
				syllables ~= tuple (s ~ "1", s.replace("o", "ō"));
				syllables ~= tuple (s ~ "2", s.replace("o", "ó"));
				syllables ~= tuple (s ~ "3", s.replace("o", "ǒ"));
				syllables ~= tuple (s ~ "4", s.replace("o", "ò"));
				syllables ~= tuple (s ~ "5", s);
				break;
			case "iou":
				if (i == "") {
					syllables ~= tuple (s ~ "1", s.replace("o", "ō"));
					syllables ~= tuple (s ~ "2", s.replace("o", "ó"));
					syllables ~= tuple (s ~ "3", s.replace("o", "ǒ"));
					syllables ~= tuple (s ~ "4", s.replace("o", "ò"));
					syllables ~= tuple (s ~ "5", s);
				}
				else {
					syllables ~= tuple (s ~ "1", s.replace("u", "ū"));
					syllables ~= tuple (s ~ "2", s.replace("u", "ú"));
					syllables ~= tuple (s ~ "3", s.replace("u", "ǔ"));
					syllables ~= tuple (s ~ "4", s.replace("u", "ù"));
					syllables ~= tuple (s ~ "5", s);
				}
				break;
			case "e":
			case "ei":		
			case "en":
			case "er":
			case "eng":
			case "ie":											
			case "ueng":				
				syllables ~= tuple (s ~ "1", s.replace("e", "ē"));
				syllables ~= tuple (s ~ "2", s.replace("e", "é"));
				syllables ~= tuple (s ~ "3", s.replace("e", "ě"));
				syllables ~= tuple (s ~ "4", s.replace("e", "è"));
				syllables ~= tuple (s ~ "5", s);
				break;
			case "uei":
				if (i == "") {
					syllables ~= tuple (s ~ "1", s.replace("e", "ē"));
					syllables ~= tuple (s ~ "2", s.replace("e", "é"));
					syllables ~= tuple (s ~ "3", s.replace("e", "ě"));
					syllables ~= tuple (s ~ "4", s.replace("e", "è"));
					syllables ~= tuple (s ~ "5", s);					
				}
				else {
					syllables ~= tuple (s ~ "1", s.replace("i", "ī"));
					syllables ~= tuple (s ~ "2", s.replace("i", "í"));
					syllables ~= tuple (s ~ "3", s.replace("i", "ǐ"));
					syllables ~= tuple (s ~ "4", s.replace("i", "ì"));
					syllables ~= tuple (s ~ "5", s);
				}
				break;
			case "uen":
				if (i == "") {
					syllables ~= tuple (s ~ "1", s.replace("e", "ē"));
					syllables ~= tuple (s ~ "2", s.replace("e", "é"));
					syllables ~= tuple (s ~ "3", s.replace("e", "ě"));
					syllables ~= tuple (s ~ "4", s.replace("e", "è"));
					syllables ~= tuple (s ~ "5", s);					
				}
				else {
					syllables ~= tuple (s ~ "1", s.replace("u", "ū"));
					syllables ~= tuple (s ~ "2", s.replace("u", "ú"));
					syllables ~= tuple (s ~ "3", s.replace("u", "ǔ"));
					syllables ~= tuple (s ~ "4", s.replace("u", "ù"));
					syllables ~= tuple (s ~ "5", s);
				}
				break;
			case "i":				
			case "in":
			case "ing":
				syllables ~= tuple (s ~ "1", s.replace("i", "ī"));
				syllables ~= tuple (s ~ "2", s.replace("i", "í"));
				syllables ~= tuple (s ~ "3", s.replace("i", "ǐ"));
				syllables ~= tuple (s ~ "4", s.replace("i", "ì"));
				syllables ~= tuple (s ~ "5", s);
				break;
			case "u":							
				syllables ~= tuple (s ~ "1", s.replace("u", "ū"));
				syllables ~= tuple (s ~ "2", s.replace("u", "ú"));
				syllables ~= tuple (s ~ "3", s.replace("u", "ǔ"));
				syllables ~= tuple (s ~ "4", s.replace("u", "ù"));
				syllables ~= tuple (s ~ "5", s);
				break;						
			case "v":
			case "ve":
				switch (i) {
					default:
						syllables ~= tuple (s ~ "1", s.replace("ü", "ǖ"));
						syllables ~= tuple (s ~ "2", s.replace("ü", "ǘ"));
						syllables ~= tuple (s ~ "3", s.replace("ü", "ǚ"));
						syllables ~= tuple (s ~ "4", s.replace("ü", "ǜ"));
						syllables ~= tuple (s ~ "5", s);
						break;
					case "":
					case "j":
					case "q":
					case "x":
						syllables ~= tuple (s ~ "1", s.replace("e", "ē"));
						syllables ~= tuple (s ~ "2", s.replace("e", "é"));
						syllables ~= tuple (s ~ "3", s.replace("e", "ě"));
						syllables ~= tuple (s ~ "4", s.replace("e", "è"));
						syllables ~= tuple (s ~ "5", s);
						break;						
				}							
				break;
		}
	}
	return syllables;
}

void generateConversionTable (string fileName) {
    auto data = import ("syllables.txt");	
	auto syllables =
		parseSource (data)
		.createSyllables
		.sort!((a,b) => a < b)
		.array
		.addTones;
	auto file = File (fileName, "w");
	foreach (s; syllables) {
		file.writeln(s[0] ~ "\t" ~ s[1]);
	}
	file.close();
}