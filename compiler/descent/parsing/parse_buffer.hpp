#pragma once

#include <string>

class ParseBuffer {

private:

    std::string text;

    long length;

    char get_character() const;

    void increment(const int steps);

public:

    struct Position {

    public:

        long index;

        long row;

        int column;

    };

    Position position;

    ParseBuffer(const std::string &text);

    char read();
    bool read(const char &character);
    bool read(const std::string &string);

    char peek() const;
    bool peek(const char &character) const;
    bool peek(const std::string &string) const;

    void skip();

    bool finished() const;

};

/* Gets the character at the current index

Returns
-------
character
    character at the current index (or zero if the end of the buffer has been
    reached)
*/
char ParseBuffer::get_character() const {
    if(this->position.index >= this->length)
        return 0;

    return this->text[this->position.index];
}

/* Increments the buffer's index

Increments the index, but also the column, row values

Arguments
---------
steps
    the number of steps to increment
*/
void ParseBuffer::increment(const int steps = 1) {
    Position &position = this->position;

    for(int step = 0; step < steps; step += 1) {
        if(position.index >= length)
            return;

        char character = text[position.index];
        if(character == '\t')
            position.column += 4;
        else if(character == '\n') {
            position.column = 1;
            position.row = 0;
        }
        else if(character != '\r')
            position.column += 1;

        position.index += 1;
    }
}

ParseBuffer::ParseBuffer(const std::string &text) {
    this->text = text;
    this->length = text.length();

    this->position.index = 0;
    this->position.row = 1;
    this->position.column = 1;
}

/* Reads the current character, incrementing

Returns
-------
character
    character at the current index
*/
char ParseBuffer::read() {
    char result = get_character();
    increment();
    return result;
}

/* Tries to read a character, incrementing

Arguments
---------
character
    character to check for

Returns
-------
found
    true if the character was present at the current index
*/
bool ParseBuffer::read(const char &character) {
    if(peek(character) == false)
        return false;

    increment();
    return true;
}

/* Tries to read a string, incrementing

Arguments
---------
string
    string to check for

Returns
-------
found
    true if the string was present at the current index
*/
bool ParseBuffer::read(const std::string &string) {
    if(peek(string) == false)
        return false;

    increment(string.length());
    return true;
}

/* Reads the current character, without incrementing

Returns
-------
character
    character at the current index
*/
char ParseBuffer::peek() const {
    return text[position.index];
}

/* Tries to read a character, without incrementing

Arguments
---------
character
    character to check for

Returns
-------
found
    true if the character was present at the current index
*/
bool ParseBuffer::peek(const char &character) const {
    return text[position.index] == character;
}

/* Tries to read a string, without incrementing

Arguments
---------
string
    string to check for

Returns
-------
found
    true if the string was present at the current index
*/
bool ParseBuffer::peek(const std::string &string) const {
    int string_length = string.length();
    if(position.index + string_length > length)
        return false;

    std::string thing = text.substr(position.index, string_length);
    return thing  == string;
}

/* Skips whitespace characters

Whitespace characters include: spaces, tabs (horizontal and vertical), and
carriage returns.

Note: does not consume newlines
*/
void ParseBuffer::skip() {
    while(true) {
        if(finished())
            return;

        char character = get_character();
        if(character == ' ' ||
                character == '\t' ||
                character == '\v' ||
                character == '\r')
            increment();
        else
            return;
    }
}

/* Checks if the end of the buffer has been reached

Returns
-------
finished
    true if the end of the buffer has been reached
*/
bool ParseBuffer::finished() const {
    return this->position.index >= this->length;
}
