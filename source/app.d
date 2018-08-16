import std.stdio;
import std.regex;
import std.array;
import std.algorithm;

import gencnv;

auto rxField = regex(`\t`);

auto createHashtable(string[string] hash, string line) {
	string[] fields = line.split(rxField).array;
	hash[fields[0]] = fields[1];
	return hash;
}

void main()
{
	auto conversionTable = import("conv_table.txt");
	auto rxLine = regex(`\r?\n`);
	auto rxSyllable = regex("[a-z]+[1-5]", "g");
	string[string] seed;
	auto hash =
		conversionTable
		.split(rxLine)
		.array
		.fold!createHashtable(seed);
	auto src = import ("hsk4.txt");
	auto file = File ("hsk4_o.txt", "w");
	foreach (line; src.split(rxLine)) {
		auto fields = line.split(rxField).array;
		string[] key;
		auto p = fields[1];
		foreach (c; matchAll(line, rxSyllable)){
			if(hash[c.hit]) {
				key ~= hash[c.hit];
			}
			else {
				writeln ("Error");
			}
		}
		fields[1] = key.join("");
		file.writeln(fields.join("\t"));
	}
	file.close();
}
