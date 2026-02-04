using Parse;

namespace ParseDemo
{
    [ParseClassName(nameof(Student))]
    public class Student : ParseObject
    {
        [ParseFieldName("FirstName")]
        public string FirstName
        {
            get => GetProperty<string>();
            set => SetProperty(value);
        }

        [ParseFieldName(nameof(LastName))]
        public string LastName
        {
            get => GetProperty<string>();
            set => SetProperty(value);
        }

        public override string ToString()
        {
            return $"{FirstName} {LastName}";
        }
    }
}
