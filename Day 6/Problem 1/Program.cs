// See https://aka.ms/new-console-template for more information

var data = File.ReadAllText(@"Data\inputdata.txt").ToArray();

var currentSequence = new Queue<char>(data.Take(3));
for (int i = 3; i < data.Length; i++)
{
    currentSequence.Enqueue(data[i]);
    if (IsUniqueSequence(currentSequence))
    {
        Console.WriteLine($"Unique sequence found at position '{i+1}'");
        break;
    }
    currentSequence.Dequeue();
}

bool IsUniqueSequence(Queue<char> currentSequence)
{
    foreach (var item in currentSequence)
    {
        if (currentSequence.Count(x => x.Equals(item)) > 1)
        {
            return false;
        }
    }
    return true;
}