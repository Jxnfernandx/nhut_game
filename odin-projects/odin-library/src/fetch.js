export async function fetchBookInfo(bookName, author) {
    try {
        const data = await fetch(`https://www.googleapis.com/books/v1/volumes?q=${bookName}inauthor:${author}`);
        return response = data.json();
    }
    catch {
        console.log("error");
    }
}