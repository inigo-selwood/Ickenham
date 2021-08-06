#pragma once

#include <vector>

#include "../error_vector.hpp"
#include "../parse_buffer.hpp"
#include "../token.hpp"

#include "statement.hpp"

class Source : public Token {

public:

    std::vector<Statement *> statements;

    Source(const std::vector<Statement *> &statements);

    static Source *parse(ParseBuffer &buffer, ErrorVector &errors);

};

Source::Source(const std::vector<Statement *> &statements) {
    this->statements = statements;
}

/* Parse a source object

Arguments
---------
buffer
    the buffer to parse from
errors
    error reporting context

Returns
-------
source
    the parsed source, or nullptr if an error occurs
*/
Source *Source::parse(ParseBuffer &buffer, ErrorVector &errors) {
    std::vector<Statement *> statements;
    while(true) {
        buffer.skip();
        if(buffer.finished())
            break;

        Statement *statement = Statement::parse(buffer, errors);
        if(statement == nullptr)
            return nullptr;

        statements.push_back(statement);
    }

    return new Source(statements);
}
