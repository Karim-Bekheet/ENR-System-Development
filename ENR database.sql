-- Create the database
CREATE DATABASE RailwayManagementSystem;
GO

USE RailwayManagementSystem;
GO

-- Create Passenger (User) table
CREATE TABLE Passenger (
    UserID INT PRIMARY KEY IDENTITY(1,1),
    FullName NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    PhoneNum NVARCHAR(20) NOT NULL,
    NationalID NVARCHAR(50) UNIQUE NOT NULL,
    DateOfBirth DATE NOT NULL
);
GO

-- Create Train table
CREATE TABLE Train (
    TrainID INT PRIMARY KEY IDENTITY(1,1),
    TrainName NVARCHAR(100) NOT NULL,
    Type NVARCHAR(50) NOT NULL,
    Manufacturer NVARCHAR(100) NOT NULL,
    TotalCapacity INT NOT NULL
);
GO

-- Create Station table
CREATE TABLE Station (
    StationID INT PRIMARY KEY IDENTITY(1,1),
    StationName NVARCHAR(100) NOT NULL,
    City NVARCHAR(100) NOT NULL,
    Capacity INT NOT NULL
);
GO

-- Create Schedule table
CREATE TABLE Schedule (
    ScheduleID INT PRIMARY KEY IDENTITY(1,1),
    TravelDate DATE NOT NULL,
    DepartureTime TIME NOT NULL,
    ArrivalTime TIME NOT NULL,
    TrainID INT NOT NULL,
    FOREIGN KEY (TrainID) REFERENCES Train(TrainID)
);
GO

-- Create Coach table
CREATE TABLE Coach (
    CoachID INT PRIMARY KEY IDENTITY(1,1),
    CoachNum NVARCHAR(20) NOT NULL,
    CoachType NVARCHAR(50) NOT NULL,
    TrainID INT NOT NULL,
    FOREIGN KEY (TrainID) REFERENCES Train(TrainID)
);
GO

-- Create Seat table
CREATE TABLE Seat (
    SeatNum INT PRIMARY KEY IDENTITY(1,1),
    SeatType NVARCHAR(50) NOT NULL,
    IsAvailable BIT NOT NULL DEFAULT 1,
    CoachID INT NOT NULL,
    FOREIGN KEY (CoachID) REFERENCES Coach(CoachID)
);
GO

-- Create Ticket table
CREATE TABLE Ticket (
    TicketID INT PRIMARY KEY IDENTITY(1,1),
    BookingDate DATETIME NOT NULL DEFAULT GETDATE(),
    TicketPrice DECIMAL(10,2) NOT NULL,
    PaymentStatus NVARCHAR(20) NOT NULL,
    UserID INT NOT NULL,
    ScheduleID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Passenger(UserID),
    FOREIGN KEY (ScheduleID) REFERENCES Schedule(ScheduleID)
);
GO

-- Create junction table for Ticket and Seat (M:N relationship)
CREATE TABLE TicketSeat (
    TicketID INT NOT NULL,
    SeatNum INT NOT NULL,
    PRIMARY KEY (TicketID, SeatNum),
    FOREIGN KEY (TicketID) REFERENCES Ticket(TicketID),
    FOREIGN KEY (SeatNum) REFERENCES Seat(SeatNum)
);
GO

-- Create junction table for Schedule and Station (M:N relationship)
CREATE TABLE ScheduleStation (
    ScheduleID INT NOT NULL,
    StationID INT NOT NULL,
    PRIMARY KEY (ScheduleID, StationID),
    FOREIGN KEY (ScheduleID) REFERENCES Schedule(ScheduleID),
    FOREIGN KEY (StationID) REFERENCES Station(StationID)
);
GO

-- Create Feedback table
CREATE TABLE Feedback (
    FeedbackID INT PRIMARY KEY IDENTITY(1,1),
    Message NVARCHAR(MAX) NOT NULL,
    Date DATETIME NOT NULL DEFAULT GETDATE(),
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Passenger(UserID)
);
GO

-- Create ServiceReservation table
CREATE TABLE ServiceReservation (
    ReservationID INT PRIMARY KEY IDENTITY(1,1),
    ServiceType NVARCHAR(50) NOT NULL,
    Details NVARCHAR(MAX),
    UserID INT NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Passenger(UserID)
);
GO

-- Create Hospital table
CREATE TABLE Hospital (
    HospitalID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    ContactNumber NVARCHAR(20) NOT NULL
);
GO

-- Create Restaurant table
CREATE TABLE Restaurant (
    RestaurantID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    Location NVARCHAR(200) NOT NULL,
    CuisineType NVARCHAR(50) NOT NULL
);
GO

-- Create Bank table
CREATE TABLE Bank (
    BankID INT PRIMARY KEY IDENTITY(1,1),
    Name NVARCHAR(100) NOT NULL,
    BranchLocation NVARCHAR(200) NOT NULL,
    ContactNumber NVARCHAR(20) NOT NULL
);
GO

-- Create junction table for Train and Hospital (M:N relationship)
CREATE TABLE TrainHospital (
    TrainID INT NOT NULL,
    HospitalID INT NOT NULL,
    PRIMARY KEY (TrainID, HospitalID),
    FOREIGN KEY (TrainID) REFERENCES Train(TrainID),
    FOREIGN KEY (HospitalID) REFERENCES Hospital(HospitalID)
);
GO

-- Create junction table for Train and Restaurant (M:N relationship)
CREATE TABLE TrainRestaurant (
    TrainID INT NOT NULL,
    RestaurantID INT NOT NULL,
    PRIMARY KEY (TrainID, RestaurantID),
    FOREIGN KEY (TrainID) REFERENCES Train(TrainID),
    FOREIGN KEY (RestaurantID) REFERENCES Restaurant(RestaurantID)
);
GO

-- Add foreign key for Ticket PROCESSED BY Bank (M:1 relationship)
ALTER TABLE Ticket
ADD BankID INT NULL,
CONSTRAINT FK_Ticket_Bank FOREIGN KEY (BankID) REFERENCES Bank(BankID);
GO

-- Add indexes for better performance
CREATE INDEX IX_Ticket_UserID ON Ticket(UserID);
CREATE INDEX IX_Ticket_ScheduleID ON Ticket(ScheduleID);
CREATE INDEX IX_Coach_TrainID ON Coach(TrainID);
CREATE INDEX IX_Seat_CoachID ON Seat(CoachID);
CREATE INDEX IX_Schedule_TrainID ON Schedule(TrainID);
CREATE INDEX IX_Feedback_UserID ON Feedback(UserID);
CREATE INDEX IX_ServiceReservation_UserID ON ServiceReservation(UserID);
GO