"use strict";

import { Book } from './Book.js';
// import { fetchBookInfo } from './fetch.js';

const addBtn = document.getElementById("addBtn");
const authorInput = document.getElementById("author");
const titleInput = document.getElementById("title");
const pagesInput = document.getElementById("pages");
const myLibrary = [];

function addBookToLibrary() {
    let book = new Book(authorInput.value, titleInput.value, pagesInput.value);
    myLibrary.push(book);
    console.log(myLibrary);
}
addBtn.addEventListener("click", addBookToLibrary);

const bookName = "flowersforalgernon";
const author = "keyes";

async function fetchBookInfo(bookName, author) {
    try {
        const data = await fetch(`https://www.googleapis.com/books/v1/volumes?q=${bookName}inauthor:${author}`);
        return await data.json();
    }
    catch {
        console.log("error");
    }
}

