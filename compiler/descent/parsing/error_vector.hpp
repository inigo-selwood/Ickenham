#pragma once

#include <string>
#include <vector>

#include "parse_buffer.hpp"

class ErrorVector {

public:

    struct Error {

    public:

        std::string message;

        ParseBuffer::Position position;

        Error(const std::string &message,
                const ParseBuffer::Position &position);

    };

    ErrorVector() {}

    void add(const std::string &message, const ParseBuffer::Position &position);

private:

    std::vector<Error> errors;

};

ErrorVector::Error::Error(const std::string &message,
        const ParseBuffer::Position &position) {

    this->message = message;
    this->position = position;
}

void ErrorVector::add(const std::string &message,
        const ParseBuffer::Position &position) {

    this->errors.push_back(Error(message, position));
}
