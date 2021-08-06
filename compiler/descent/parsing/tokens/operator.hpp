#pragma once

#include <vector>
#include <utility>

#include "../parse_logic_exception.hpp"

namespace Operator {

enum Symbol {
    INTEGER_ADD,
    INTEGER_SUBTRACT,
    INTEGER_MULTIPLY,
    INTEGER_DIVIDE,
    INTEGER_REMAINDER,

    NUMERIC_ADD,
    NUMERIC_SUBTRACT,
    NUMERIC_MULTIPLY,
    NUMERIC_DIVIDE,
    NUMERIC_REMAINDER,

    BITWISE_AND,
    BITWISE_OR,
    BITWISE_EXCLUSIVE_OR,
    BITWISE_SHIFT_LEFT,
    BITWISE_SHIFT_RIGHT,
    BITWISE_SHIFT_RIGHT_SIGNED,

    COMPARISON_EQUAL,
    COMPARISON_NOT_EQUAL,

    COMPARISON_INTEGER_LESS,
    COMPARISON_INTEGER_MORE,
    COMPARISON_INTEGER_NOT_MORE,
    COMPARISON_INTEGER_NOT_LESS,

    COMPARISON_NUMERIC_LESS,
    COMPARISON_NUMERIC_MORE,
    COMPARISON_NUMERIC_NOT_MORE,
    COMPARISON_NUMERIC_NOT_LESS,

    ASSIGN_INTEGER_ADD,
    ASSIGN_INTEGER_SUBTRACT,
    ASSIGN_INTEGER_MULTIPLY,
    ASSIGN_INTEGER_DIVIDE,
    ASSIGN_INTEGER_REMAINDER,

    ASSIGN_NUMERIC_ADD,
    ASSIGN_NUMERIC_SUBTRACT,
    ASSIGN_NUMERIC_MULTIPLY,
    ASSIGN_NUMERIC_DIVIDE,
    ASSIGN_NUMERIC_REMAINDER,

    ASSIGN_BITWISE_AND,
    ASSIGN_BITWISE_OR,
    ASSIGN_BITWISE_EXCLUSIVE_OR,
    ASSIGN_BITWISE_SHIFT_LEFT,
    ASSIGN_BITWISE_SHIFT_RIGHT,
    ASSIGN_BITWISE_SHIFT_RIGHT_SIGNED,
};

/* Parse a symbol

Arguments
---------
buffer
    the buffer to parse a symbol from
errors
    error reporting context

Returns
-------
symbol
    the enumeration equivalent of the symbol found

Throws
------
parse_logic_exception
    if no symbol was found    
*/
Symbol parse(ParseBuffer &buffer, ErrorVector &errors) {
    static const std::vector<std::pair<char, Symbol>> letter_symbols = {
        {'+',   Symbol::INTEGER_ADD},
        {'-',	Symbol::INTEGER_SUBTRACT},
        {'*',	Symbol::INTEGER_MULTIPLY},
        {'/',	Symbol::INTEGER_DIVIDE},
        {'%',	Symbol::INTEGER_REMAINDER},

        {'&',	Symbol::BITWISE_AND},
        {'|',	Symbol::BITWISE_OR},
        {'^',	Symbol::BITWISE_EXCLUSIVE_OR},

        {'<',	Symbol::COMPARISON_INTEGER_LESS},
        {'>',	Symbol::COMPARISON_INTEGER_MORE}
    };

    static const std::vector<std::pair<std::string, Symbol>> string_symbols = {
        {".+",		Symbol::NUMERIC_ADD},
        {".-",		Symbol::NUMERIC_SUBTRACT},
        {".*",		Symbol::NUMERIC_MULTIPLY},
        {"./",		Symbol::NUMERIC_DIVIDE},
        {".%",		Symbol::NUMERIC_REMAINDER},

        {"<<",		Symbol::BITWISE_SHIFT_LEFT},
        {">>",		Symbol::BITWISE_SHIFT_RIGHT},
        {"->>",		Symbol::BITWISE_SHIFT_RIGHT_SIGNED},

        {"==",		Symbol::COMPARISON_EQUAL},
        {"!=",		Symbol::COMPARISON_NOT_EQUAL},

        {"<=",		Symbol::COMPARISON_INTEGER_LESS},
        {">=",		Symbol::COMPARISON_INTEGER_MORE},

        {".<",		Symbol::COMPARISON_NUMERIC_LESS},
        {".>",		Symbol::COMPARISON_NUMERIC_MORE},
        {".<=",		Symbol::COMPARISON_NUMERIC_NOT_MORE},
        {".>=",		Symbol::COMPARISON_NUMERIC_NOT_LESS},

        {"+=",		Symbol::ASSIGN_INTEGER_ADD},
        {"-=",		Symbol::ASSIGN_INTEGER_SUBTRACT},
        {"*=",		Symbol::ASSIGN_INTEGER_MULTIPLY},
        {"/=",		Symbol::ASSIGN_INTEGER_DIVIDE},
        {"%=",		Symbol::ASSIGN_INTEGER_REMAINDER},

        {".+=",		Symbol::ASSIGN_NUMERIC_ADD},
        {".-=",		Symbol::ASSIGN_NUMERIC_SUBTRACT},
        {".*=",		Symbol::ASSIGN_NUMERIC_MULTIPLY},
        {"./=",		Symbol::ASSIGN_NUMERIC_DIVIDE},
        {".%=",		Symbol::ASSIGN_NUMERIC_REMAINDER},

        {"&=",		Symbol::ASSIGN_BITWISE_AND},
        {"|=",		Symbol::ASSIGN_BITWISE_OR},
        {"^=",		Symbol::ASSIGN_BITWISE_EXCLUSIVE_OR},
        {"<<=",		Symbol::ASSIGN_BITWISE_SHIFT_LEFT},
        {">>=",		Symbol::ASSIGN_BITWISE_SHIFT_RIGHT},
        {"->>=",	Symbol::ASSIGN_BITWISE_SHIFT_RIGHT_SIGNED}
    };

    for(auto iterator = string_symbols.rbegin(); iterator != string_symbols.rend(); iterator ++) {
        if(buffer.read(iterator->first))
            return iterator->second;
    }

    for(auto iterator = letter_symbols.begin(); iterator != letter_symbols.end(); iterator ++) {
        if(buffer.read(iterator->first))
            return iterator->second;
    }

    throw ParseLogicException();
}

}; // Namespace Operator
