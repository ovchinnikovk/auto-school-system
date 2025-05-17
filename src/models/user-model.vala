public class Answer : Object
{
    public int? id { get; set; }
    public string answerText { get; set; }
    public bool? status { get; set; }
}

public class Car : Object
{
    public int? id { get; set; }
    public CarMark carMark { get; set; }
    public string carModel { get; set; }
    public string stateNumber { get; set; }
    public string productionYear { get; set; }
    public string vinNumber { get; set; }
    public Category category { get; set; }
    public string image { get; set; }
}

public class CarMark : Object
{
    public int? id { get; set; }
    public string title { get; set; }
}

public class Category : Object
{
    public int? id { get; set; }
    public string title { get; set; }
    public string description { get; set; }
}

public class Course : Object
{
    public int? id { get; set; }
    public string title { get; set; }
    public string description { get; set; }
    public Gee.ArrayList<Lesson> lessons { get; set; }
    public Category category { get; set; }
    public int? price { get; set; }
    public Gee.ArrayList<CourseQuiz> courseQuizzes { get; set; }
}

public class CourseQuiz : Object
{
    public int? id { get; set; }
    public string question { get; set; }
    public Gee.ArrayList<Answer> answers { get; set; }
    public int? orderNumber { get; set; }
    public string image { get; set; }
}

public class Exam : Object
{
    public int? id { get; set; }
    public DateTime? date { get; set; }
}

public class Lesson : Object
{
    public int? id { get; set; }
    public string title { get; set; }
    public string description { get; set; }
    public string types { get; set; }
    public string teacher { get; set; }
    public DateTime? date { get; set; }
    public Gee.ArrayList<Video> videos { get; set; }
    public int? orderNumber { get; set; }
}

public class Review : Object
{
    public int? id { get; set; }
    public string title { get; set; }
    public string description { get; set; }
}

public class User : Object
{
    public int? id { get; set; }
    public string name { get; set; }
    public string surname { get; set; }
    public string patronym { get; set; }
    public string phone { get; set; }
    public string email { get; set; }
    public string telegramId { get; set; }
    public DateTime? dateOfBirth { get; set; }
    public string contract { get; set; }
    public bool? examStatus { get; set; }
    public string license { get; set; }
    public int? experience { get; set; }
    public DateTime? hireDate { get; set; }
    public DateTime? enrollDate { get; set; }
    public Gee.ArrayList<string> roles { get; set; }
    public bool? is_active { get; set; }
    public bool? is_approved { get; set; }
    public string aboutMe { get; set; }
    public Exam exam { get; set; }
    public Gee.ArrayList<Review> reviews { get; set; }
    public Gee.ArrayList<Course> courses { get; set; }
    public Car car { get; set; }
    public string image { get; set; }
    public Category category { get; set; }
}

public class Video : Object
{
    public int? id { get; set; }
    public string video { get; set; }
}
