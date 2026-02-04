using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Text;

namespace ListDemos
{
    // From https://updatecontrols.net/doc/node/39.html
    public class MappedBindingList<TSource, TTarget>
    {
        private Func<TSource, TTarget> _map;
        private IEnumerable<TSource> _sourceCollection;
        private BindingList<TTarget> _targetCollection = new BindingList<TTarget>();
        private Func<TSource> _factory;

        public MappedBindingList(IEnumerable<TSource> sourceCollection, Func<TSource, TTarget> map, Func<TSource> factory)
        {
            _map = map;
            _sourceCollection = sourceCollection;
            _factory = factory;

            _targetCollection.AllowNew = true;
            _targetCollection.AllowEdit = true;
            _targetCollection.AllowRemove = true;
            _targetCollection.AddingNew += TargetCollection_AddingNew;

            var notifyCollectionChanged = sourceCollection as INotifyCollectionChanged;
            if (notifyCollectionChanged != null)
                notifyCollectionChanged.CollectionChanged += SourceCollectionChanged;
            PopulateTargetCollection();
        }

        private void TargetCollection_AddingNew(object sender, AddingNewEventArgs e)
        {
            e.NewObject = _map(_factory());
        }

        public BindingList<TTarget> TargetCollection
        {
            get { return _targetCollection; }
        }

        private void SourceCollectionChanged(object sender, NotifyCollectionChangedEventArgs e)
        {
            if (e.Action == NotifyCollectionChangedAction.Add)
            {
                // Add the corresponding targets.
                int index = e.NewStartingIndex;
                foreach (TSource item in e.NewItems)
                {
                    _targetCollection.Insert(index, _map(item));
                    ++index;
                }
            }
            else if (e.Action == NotifyCollectionChangedAction.Remove)
            {
                // Delete the corresponding targets.
                for (int i = 0; i < e.OldItems.Count; i++)
                {
                    _targetCollection.RemoveAt(e.OldStartingIndex);
                }
            }
            else if (e.Action == NotifyCollectionChangedAction.Replace)
            {
                // Replace the corresponding targets.
                for (int i = 0; i < e.OldItems.Count; i++)
                {
                    _targetCollection[i + e.OldStartingIndex] = _map((TSource)e.NewItems[i + e.NewStartingIndex]);
                }
            }
            else
            {
                // Just give up and start over.
                _targetCollection.Clear();
                PopulateTargetCollection();
            }
        }

        private void PopulateTargetCollection()
        {
            foreach (TSource item in _sourceCollection)
            {
                _targetCollection.Add(_map(item));
            }
        }
    }
}
