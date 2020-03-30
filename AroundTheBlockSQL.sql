CREATE TABLE Neighborhood (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	[Name] VARCHAR(55) NOT NULL
);

CREATE TABLE [Owner] (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	[Name] VARCHAR(55) NOT NULL,
	[Address] VARCHAR(255) NOT NULL,
	NeighborhoodId INTEGER,
	Phone VARCHAR(55) NOT NULL,
	CONSTRAINT FK_Owner_Neighborhood FOREIGN KEY (NeighborhoodId) REFERENCES Neighborhood(Id)
);

CREATE TABLE Dog (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	[Name] VARCHAR(55) NOT NULL,
	OwnerId INTEGER NOT NULL,
	Breed VARCHAR(55) NOT NULL,
	Notes VARCHAR(255),
	CONSTRAINT FK_Dog_Owner FOREIGN KEY (OwnerId) REFERENCES [Owner](Id)
);

CREATE TABLE Walker (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	[Name] VARCHAR(55) NOT NULL,
	NeighborhoodId INTEGER,
	CONSTRAINT FK_Walker_Neighborhood FOREIGN KEY (NeighborhoodId) REFERENCES Neighborhood(Id)
);

CREATE TABLE Walks (
	Id INTEGER NOT NULL PRIMARY KEY IDENTITY,
	[Date] DATETIME NOT NULL,
	Duration INTEGER NOT NULL,
	WalkerId INTEGER NOT NULL,
	DogId INTEGER NOT NULL,
	CONSTRAINT FK_Walks_Walker FOREIGN KEY (WalkerId) REFERENCES Walker(Id),
	CONSTRAINT FK_Walks_Dog FOREIGN KEY (DogId) REFERENCES Dog(Id)
);

INSERT INTO Neighborhood ([Name]) VALUES ('Hillsboro');
INSERT INTO Neighborhood ([Name]) VALUES ('West End');
INSERT INTO Neighborhood ([Name]) VALUES ('Five Points');
INSERT INTO Neighborhood ([Name]) VALUES ('Brentwood');

INSERT INTO [Owner] ([Name], [Address], NeighborhoodId, Phone) VALUES ('Rachel Green', '123 Hillsboro Pike', 1, '(615)-555-1234');
INSERT INTO [Owner] ([Name], [Address], NeighborhoodId, Phone) VALUES ('Ross Geller', '233 West End Ave', 2, '(615)-555-2313');
INSERT INTO [Owner] ([Name], [Address], NeighborhoodId, Phone) VALUES ('Monica Geller', '989 12th Ave S', 1, '(615)-555-3235');
INSERT INTO [Owner] ([Name], [Address], NeighborhoodId, Phone) VALUES ('Chandler Bing', '495 Woodland St', 3, '(615)-555-8914');
INSERT INTO [Owner] ([Name], [Address], NeighborhoodId, Phone) VALUES ('Joey Tribbiani', '880 Blair Blvd', 2, '(615)-555-3412');
INSERT INTO [Owner] ([Name], [Address], NeighborhoodId, Phone) VALUES ('Walter White', '533 W Linden Ave', 1, '(615)-555-4188');
INSERT INTO [Owner] ([Name], [Address], NeighborhoodId, Phone) VALUES ('Fiona Gallegher', '223 Sunset Blvd', 1, '(615)-555-6748');

INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Bublles', 1, 'Siberian Husky');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Remi', 1, 'Goldendoodle');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Finnley', 2, 'Goldendoodle');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Wrigley', 3, 'Great Dane');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Willow', 3, 'Bernedoodle');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Bernie', 4, 'Chihuahua');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Hogan', 5, 'Golden Retriever');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Stella', 6, 'Goldendoodle');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Max', 7, 'English Bulldog');
INSERT INTO Dog ([Name], OwnerId, Breed) VALUES ('Leo', 7, 'Aussiedoodle');

INSERT INTO Walker ([Name], NeighborhoodId) VALUES ('Frank Gallagher', 1);
INSERT INTO Walker ([Name], NeighborhoodId) VALUES ('Jessica Day', 1);
INSERT INTO Walker ([Name], NeighborhoodId) VALUES ('Ellen DeGeneres', 2);
INSERT INTO Walker ([Name], NeighborhoodId) VALUES ('Jimmy Fallon', 3);

INSERT INTO Walks ([Date], Duration, WalkerId, DogId) VALUES ('2020-03-27 07:30:00', 2000, 1, 1);
INSERT INTO Walks ([Date], Duration, WalkerId, DogId) VALUES ('2020-03-27 20:00:00', 1200, 4, 2);
INSERT INTO Walks ([Date], Duration, WalkerId, DogId) VALUES ('2020-03-30 17:30:00', 1275, 2, 6);
INSERT INTO Walks ([Date], Duration, WalkerId, DogId) VALUES ('2020-03-30 08:30:00', 1800, 3, 9);
INSERT INTO Walks ([Date], Duration, WalkerId, DogId) VALUES ('2020-04-01 12:00:00', 1750, 4, 10);
INSERT INTO Walks ([Date], Duration, WalkerId, DogId) VALUES ('2020-04-11 09:00:00', 900, 3, 7);
INSERT INTO Walks ([Date], Duration, WalkerId, DogId) VALUES ('2020-04-16 13:30:00', 2000, 4, 3);
INSERT INTO Walks ([Date], Duration, WalkerId, DogId) VALUES ('2020-04-16 13:30:00', 3000, 4, 1);

-- All owners names and the name of their neighborhood
SELECT o.[Name], n.[Name]
FROM [Owner] o
LEFT JOIN Neighborhood n ON o.NeighborhoodId = n.Id

-- Name and neighborhood of a single owner (can be any Id)
SELECT o.[Name], n.[Name]
FROM [Owner] o
LEFT JOIN Neighborhood n ON o.NeighborhoodId = n.Id
WHERE o.Id = 3

-- Return all walkers ordered by their name
SELECT *
FROM Walker
ORDER BY [Name] ASC

-- Return a list of unique dog breeds
SELECT DISTINCT Breed
FROM Dog

-- Return a list of all dog's names along with their owner's name and what neighborhood they live in
SELECT d.[Name] AS [Dog's Name], o.[Name], n.[Name] AS Neighborhood
FROM Dog d
LEFT JOIN [Owner] o ON d.OwnerId = o.Id
LEFT JOIN Neighborhood n ON o.NeighborhoodId = n.Id

-- Return a list of owners along with a count of how many dogs they have
SELECT o.[Name], COUNT(d.OwnerId) AS Dogs
FROM Dog d
LEFT JOIN [Owner] o ON d.OwnerId = o.Id
GROUP BY o.[Name]

-- Return a list of walkers along with the amount of walks they've recorded
SELECT wr.[Name], COUNT(ws.WalkerId) AS Walks
FROM Walks ws
LEFT JOIN Walker wr ON ws.WalkerId = wr.Id
GROUP BY wr.[Name]

-- Return a list of all neighborhoods with a count of how many walkers are in each, but do not show neighborhoods that don't have any walkers
SELECT n.[Name] AS Neighborhood, COUNT(w.NeighborhoodId) AS Walkers
FROM Walker w
LEFT JOIN Neighborhood n ON w.NeighborhoodId = n.Id
GROUP BY n.[Name]

-- Return a list of dogs that have been walked in the past week
SELECT * 
FROM Walks
WHERE [Date] BETWEEN '2020-03-23 00:00:00' AND GETDATE();

-- Return a list of dogs that have not been on a walk
SELECT d.[Name], d.Breed
FROM Dog d
LEFT JOIN Walks w ON d.Id = w.DogId
WHERE w.Id IS NULL
GROUP BY d.[Name], d.Breed
